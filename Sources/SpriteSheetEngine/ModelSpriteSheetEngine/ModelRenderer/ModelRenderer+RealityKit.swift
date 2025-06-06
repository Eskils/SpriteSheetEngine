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
    init() {
        let arView = ARView()
        self.sceneUpdateIterator = AsyncStream { continuation in
            let cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
                continuation.yield(event)
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
        self.arView = arView
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
}

extension RealityKitModelRenderer: ModelRenderer {
    @MainActor
    func add(model: Entity) {
        let anchorEntity = AnchorEntity(world: .zero)
        anchorEntity.addChild(model)
        scene.addAnchor(anchorEntity)
    }
    
    @MainActor
    func configure(camera: CameraSettings) async throws(RealityKitModelRendererError) {
        switch camera.background {
        case .color(let color):
            arView.environment.background = .color(ARView.Environment.Color(cgColor: color) ?? .black)
        case .transparent:
            arView.environment.background = .color(.clear)
        }
        
        self.camera = switch camera.projection {
        case .orthographic: if #available(macOS 15.0, *) {
            orthographicCamera(transform: camera.transform)
        } else {
            throw .orthographicCameraRequiresMacOS15
        }
        case .perspective: perspectiveCamera(transform: camera.transform)
        }
    }
    
    @MainActor
    func perform(operation: ModelOperation) async throws(RealityKitModelRendererError) -> CGImage {
        switch operation {
        case .none:
            break
        case .transform(let transform):
            let entity = try node(named: transform.nodeID)
            entity.transform.matrix = transform.matrix
        case .material(let material):
            let entity = try node(named: material.nodeID)
            guard var modelComponent = entity.components[ModelComponent.self] else {
                throw .nodeDoesNotHaveMesh(id: material.nodeID)
            }
            var meshMaterial = modelComponent.materials.first as? PhysicallyBasedMaterial ?? PhysicallyBasedMaterial()
            meshMaterial.baseColor = PhysicallyBasedMaterial.BaseColor(tint: NSColor(cgColor: material.color) ?? .magenta)
            if modelComponent.materials.count <= 1 {
                modelComponent.materials = [meshMaterial]
            } else {
                modelComponent.materials.replaceSubrange(0..<1, with: [meshMaterial])
            }
        }
        let image = try await snapshotNextFrame()
        return image
    }
}

enum RealityKitModelRendererError: Error {
    case orthographicCameraRequiresMacOS15
    case cannotCaptureSceneToImage
    case cannotConvertToCoreGraphicsImage
    case cannotFindNodeWithID(id: String)
    case nodeDoesNotHaveMesh(id: String)
    case otherError(Error)
}
