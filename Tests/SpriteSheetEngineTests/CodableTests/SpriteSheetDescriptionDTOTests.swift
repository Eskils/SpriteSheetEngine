//
//  SpriteSheetDescriptionDTOTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 13/06/2025.
//

import Testing
@testable import SpriteSheetEngine
import Foundation
import simd
import CoreGraphics
import RealityKit

struct SpriteSheetDescriptionDTOTests {
    let decoder = JSONDecoder()
    
    let testsDirectory = URL(fileURLWithPath: #filePath + "/../../").standardizedFileURL.path
    private var usdModelPath: String {
        filePath(name: "cylinder-and-cone.usdc", directory: "Models")
    }
    
    @Test
    func decode() throws {
        let string = """
        {
            "model": "\(usdModelPath)",
            "camera": {
                "background": "#aabbcc",
                "projection": "orthographic",
                "transform": [
                    1,0,0,0,
                    0,1,0,0,
                    0,0,1,6,
                    0,0,0,1
                ]
            },
            "operations": [
                {
                    "type": "transform",
                    "nodeID": "cylinder",
                    "matrix": [
                        1,0,0,0,
                        0,1,0,2,
                        0,0,1,0,
                        0,0,0,1
                    ]
                },
                {
                    "type": "material",
                    "nodeID": "cone",
                    "color": "#AABBCC"
                }
            ],
            "numberOfColumns": 4,
            "export": {
                "size": [347, 219],
                "kind": "image",
                "format": "jpeg"
            }
        }
        """
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(SpriteSheetDescription.ModelDTO.self, from: encoded)
        let expected = SpriteSheetDescription.ModelDTO(
            model: ModelKindDTO(url: URL(filePath: usdModelPath)),
            camera: CameraSettingsDTO(
                transform: Matrix4x4DTO(
                    numbers: [
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 6,
                        0, 0, 0, 1
                    ]
                ),
                projection: .orthographic,
                background: .hex(0xAABBCC)
            ),
            operations: [
                .transform(
                    ModelOperation.TransformDTO(
                        type: .transform,
                        nodeID: "cylinder",
                        matrix: Matrix4x4DTO(
                            numbers: [
                                1, 0, 0, 0,
                                0, 1, 0, 2,
                                0, 0, 1, 0,
                                0, 0, 0, 1
                            ]
                        )
                    )
                ),
                .material(
                    ModelOperation.MaterialDTO(
                        type: .material,
                        nodeID: "cone",
                        color: .hex(0xAABBCC)
                    )
                )
            ],
            numberOfColumns: 4,
            export: ExportSettingsDTO(
                size: Vector2DTO(x: 347, y: 219),
                kind: .image,
                format: .jpeg
            )
        )
        #expect(dto == expected)
    }
    
    @Test
    @MainActor
    func toModel() throws {
        let dto = SpriteSheetDescription.ModelDTO(
            model: ModelKindDTO(url: URL(filePath: usdModelPath)),
            camera: CameraSettingsDTO(
                transform: Matrix4x4DTO(
                    numbers: [
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 6,
                        0, 0, 0, 1
                    ]
                ),
                projection: .orthographic,
                background: .hex(0xAABBCC)
            ),
            operations: [
                .transform(
                    ModelOperation.TransformDTO(
                        type: .transform,
                        nodeID: "cylinder",
                        matrix: Matrix4x4DTO(
                            numbers: [
                                1, 0, 0, 0,
                                0, 1, 0, 2,
                                0, 0, 1, 0,
                                0, 0, 0, 1
                            ]
                        )
                    )
                ),
                .material(
                    ModelOperation.MaterialDTO(
                        type: .material,
                        nodeID: "cone",
                        color: .hex(0xAABBCC)
                    )
                )
            ],
            numberOfColumns: 4,
            export: ExportSettingsDTO(
                size: Vector2DTO(x: 347, y: 219),
                kind: .image,
                format: .jpeg
            )
        )
        let model = try dto.toModel()
        let expected = SpriteSheetDescription.Model(
            model: .realityKit(try Entity.load(contentsOf: URL(filePath: usdModelPath))),
            camera: CameraSettings(
                transform: simd_float4x4(
                    rows: [
                        SIMD4(1, 0, 0, 0),
                        SIMD4(0, 1, 0, 0),
                        SIMD4(0, 0, 1, 6),
                        SIMD4(0, 0, 0, 1),
                    ]
                ),
                projection: .orthographic,
                background: .color(CGColor(red: 170.0 / 255, green: 187.0 / 255, blue: 204.0 / 255, alpha: 1))
            ),
            operations: [
                .transform(
                    ModelOperation.Transform(
                        nodeID: "cylinder",
                        matrix: simd_float4x4(
                            rows: [
                                SIMD4(1, 0, 0, 0),
                                SIMD4(0, 1, 0, 2),
                                SIMD4(0, 0, 1, 0),
                                SIMD4(0, 0, 0, 1),
                            ]
                        )
                    )
                ),
                .material(
                    ModelOperation.Material(
                        nodeID: "cone",
                        color: CGColor(red: 170.0 / 255, green: 187.0 / 255, blue: 204.0 / 255, alpha: 1)
                    )
                )
            ],
            numberOfColumns: 4,
            export: ExportSettings(
                size: CGSize(width: 347, height: 219),
                kind: .image,
                format: .jpeg
            )
        )
        #expect(model == expected)
    }
    
    @Test
    @MainActor
    func emptyToModel() throws {
        let dto = SpriteSheetDescription.ModelDTO(
            model: ModelKindDTO(url: URL(filePath: usdModelPath))
        )
        let model = try dto.toModel()
        let expected = SpriteSheetDescription.Model(
            model: .realityKit(try Entity.load(contentsOf: URL(filePath: usdModelPath))),
            camera: CameraSettings(
                transform: simd_float4x4(
                    rows: [
                        SIMD4(1, 0, 0, 0),
                        SIMD4(0, 1, 0, 0),
                        SIMD4(0, 0, 1, 2),
                        SIMD4(0, 0, 0, 1),
                    ]
                ),
                projection: .perspective,
                background: .transparent
            ),
            operations: [],
            numberOfColumns: Int.max,
            export: ExportSettings(
                size: CGSize(width: 128, height: 128),
                kind: .image,
                format: .png
            )
        )
        #expect(model == expected)
    }
}

private extension SpriteSheetDescriptionDTOTests {
    func filePath(name: String, directory: String) -> String {
        "\(testsDirectory)/\(directory)/\(name)"
    }
}
