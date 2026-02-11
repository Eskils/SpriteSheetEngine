//
//  ModelKindDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 12/06/2025.
//

import Foundation
import UniformTypeIdentifiers
import RealityKit
import SceneKit

struct ModelKindDTO {
    var url: URL
    
    mutating func resolvePath(relativeTo base: URL) {
        self.url = if #available(macOS 13.0, *) {
            URL(filePath: url.path(), relativeTo: base)
        } else {
            URL(fileURLWithPath: url.path, relativeTo: base)
        }
    }
}

extension ModelKindDTO: Equatable {
}

extension ModelKindDTO: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let url = try container.decode(String.self)
        if #available(macOS 13.0, *) {
            self.url = URL(filePath: url)
        } else {
            self.url = URL(fileURLWithPath: url)
        }
    }
}

extension ModelKindDTO {
    @MainActor
    func toModel() throws -> ModelKind {
        let fileExtension = url.pathExtension
        guard let contentType = UTType(filenameExtension: fileExtension) else {
            throw DataTransferError.cannotFindContentTypeForFilenameExtension(fileExtension)
        }
        switch true {
        case contentType.conforms(to: .usd),
             contentType.conforms(to: .usdz):
            do {
                return .realityKit(try Entity.load(contentsOf: url))
            } catch {
                throw DataTransferError.cannotImportRealityKitEntity(error)
            }
        #if SE_SCENE_KIT
        case contentType.conforms(to: .sceneKitScene):
            do {
                return .sceneKit(try SCNScene(url: url))
            } catch {
                throw DataTransferError.cannotImportSceneKitScene(error)
            }
        #endif
        default:
            throw DataTransferError.cannotImportModelOfType(contentType)
        }
    }
    
    enum DataTransferError: Error {
        case cannotFindContentTypeForFilenameExtension(String)
        case cannotImportModelOfType(UTType)
        case cannotImportSceneKitScene(Error)
        case cannotImportRealityKitEntity(Error)
    }
}
