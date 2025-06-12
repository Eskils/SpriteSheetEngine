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
    let url: URL
}

extension ModelKindDTO: Equatable {
}

extension ModelKindDTO: Decodable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.url = try container.decode(URL.self)
    }
}

extension ModelKindDTO {
    @MainActor
    func toModel() throws -> ModelKind {
        let fileExtension = url.pathExtension
        guard let contentType = UTType(filenameExtension: fileExtension) else {
            throw DataTransferError.cannotFindContentTypeForFilenameExtension(fileExtension)
        }
        switch contentType {
        case .usd,
             .usdz:
            do {
                return .realityKit(try Entity.load(contentsOf: url))
            } catch {
                throw DataTransferError.cannotImportRealityKitEntity(error)
            }
        case .sceneKitScene:
            do {
                return .sceneKit(try SCNScene(url: url))
            } catch {
                throw DataTransferError.cannotImportSceneKitScene(error)
            }
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
