//
//  ModelRenderer+RealityKit.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 05/06/2025.
//

import RealityKit
import AppKit
@preconcurrency import Combine

final class RealityKitModelRenderer: Sendable {
    @MainActor
    private let arView: ARView
    @MainActor
    private var camera: Entity?
    private let sceneUpdateIterator: AsyncStream<SceneEvents.Update>
    @MainActor
    private let rootNode = AnchorEntity(world: .zero)
    
    @MainActor
    init(size: CGSize = CGSize(width: 1024, height: 1024)) {
        let arView = ARView(frame: NSRect(origin: .zero, size: size))
        self.sceneUpdateIterator = AsyncStream { continuation in
            let cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
                continuation.yield(event)
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
        self.arView = arView
        scene.addAnchor(rootNode)
    }
    
    @MainActor
    var cameraTransform: simd_float4x4 {
        arView.cameraTransform.matrix
    }
    
    @MainActor
    private var scene: Scene {
        arView.scene
    }
    
    @available(macOS 15.0, *)
    @MainActor
    private func orthographicCamera(transform: float4x4) -> Entity {
        let cameraEntity = Entity()
        cameraEntity.components.set(OrthographicCameraComponent())
        cameraEntity.transform.matrix = transform
        return cameraEntity
    }
    
    @MainActor
    private func perspectiveCamera(transform: float4x4) -> Entity {
        let cameraEntity = Entity()
        cameraEntity.components.set(PerspectiveCameraComponent())
        cameraEntity.transform.matrix = transform
        return cameraEntity
    }
    
    private func snapshotNextFrame() async throws(RealityKitModelRendererError) -> CGImage {
        var iterator = sceneUpdateIterator.makeAsyncIterator()
        _ = await iterator.next()
        do {
            return try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.main.async {
                    let size = self.arView.frame.size
                    guard size.width > 0 && size.height > 0 else {
                        continuation.resume(throwing: RealityKitModelRendererError.invalidRendererSize(size: size))
                        return
                    }
                    self.arView.snapshot(saveToHDR: false) { image in
                        guard let image else {
                            continuation.resume(throwing: RealityKitModelRendererError.cannotCaptureSceneToImage)
                            return
                        }
                        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                            continuation.resume(throwing: RealityKitModelRendererError.cannotConvertToCoreGraphicsImage)
                            return
                        }
                        continuation.resume(returning: cgImage)
                    }
                }
            }
        } catch {
            if let rendererError = error as? RealityKitModelRendererError {
                throw rendererError
            } else {
                assertionFailure()
                throw .otherError(error)
            }
        }
    }
    
    @MainActor
    private func node(named name: String) throws(RealityKitModelRendererError) -> Entity {
        guard let node = scene.findEntity(named: name) else {
            throw .cannotFindNodeWithID(id: name)
        }
        return node
    }
    
    @MainActor
    private func meshNode(named name: String) throws(RealityKitModelRendererError) -> (Entity, ModelComponent) {
        let node = try node(named: name)
        if let component = node.components[ModelComponent.self] {
            return (node, component)
        }
        for child in node.children {
            if let component = child.components[ModelComponent.self] {
                return (node, component)
            }
        }
        throw .nodeDoesNotHaveMesh(id: name)
    }
}

extension RealityKitModelRenderer: ModelRenderer {
    @MainActor
    func add(model: Entity) {
        rootNode.addChild(model)
    }
    
    @MainActor
    func configure(camera: CameraSettings) async throws(RealityKitModelRendererError) {
        switch camera.background {
        case .color(let color):
            arView.environment.background = .color(ARView.Environment.Color(cgColor: color) ?? .black)
        case .transparent:
            arView.environment.background = .color(.clear)
        }
        
        let cameraEntity = switch camera.projection {
        case .orthographic: if #available(macOS 15.0, *) {
            orthographicCamera(transform: camera.transform)
        } else {
            throw .orthographicCameraRequiresMacOS15
        }
        case .perspective: perspectiveCamera(transform: camera.transform)
        }
        
        self.camera?.removeFromParent()
        add(model: cameraEntity)
        self.camera = cameraEntity
    }
    
    @MainActor
    func perform(operation: ModelOperation) async throws -> CGImage {
        switch operation {
        case .none:
            break
        case .transform(let transform):
            let entity = try node(named: transform.nodeID)
            entity.transform.matrix = transform.matrix
        case .material(let material):
            var (entity, modelComponent) = try meshNode(named: material.nodeID)
            var meshMaterial = modelComponent.materials.first as? PhysicallyBasedMaterial ?? PhysicallyBasedMaterial()
            meshMaterial.baseColor = PhysicallyBasedMaterial.BaseColor(tint: NSColor(cgColor: material.color) ?? .magenta)
            if modelComponent.materials.count <= 1 {
                modelComponent.materials = [meshMaterial]
            } else {
                modelComponent.materials.replaceSubrange(0..<1, with: [meshMaterial])
            }
            entity.components[ModelComponent.self] = modelComponent
        }
        let image = try await snapshotNextFrame()
        return image
    }
}

enum RealityKitModelRendererError: Error {
    case orthographicCameraRequiresMacOS15
    case cannotCaptureSceneToImage
    case invalidRendererSize(size: CGSize)
    case cannotConvertToCoreGraphicsImage
    case cannotFindNodeWithID(id: String)
    case nodeDoesNotHaveMesh(id: String)
    case otherError(Error)
}
