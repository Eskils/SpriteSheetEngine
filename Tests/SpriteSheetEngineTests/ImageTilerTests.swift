//
//  ImageTilerTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

import Testing
@testable import SpriteSheetEngine
import CoreGraphics
import CoreImage

struct ImageTilerTests {
    let testsDirectory = URL(fileURLWithPath: #filePath + "/../").standardizedFileURL.path
    
    @Test
    func totalSizeForEvenNumberOfImages() throws {
        let imageTiler = try ImageTiler(
            tileSize: CGSize(
                width: 90,
                height: 130
            ),
            numberOfColumns: 3,
            numberOfImages: 8
        )
        
        #expect(imageTiler.tileHeight == 130)
        #expect(imageTiler.tileWidth == 90)
        #expect(imageTiler.numberOfColumns == 3)
        #expect(imageTiler.numberOfImages == 8)
        
        let expectedWidth = 90 * 3
        #expect(imageTiler.context.width == expectedWidth)
        
        let expectedHeight = 130 * 3
        #expect(imageTiler.context.height == expectedHeight)
    }
    
    @Test
    func totalSizeForOddNumberOfImages() throws {
        let imageTiler = try ImageTiler(
            tileSize: CGSize(
                width: 90,
                height: 130
            ),
            numberOfColumns: 3,
            numberOfImages: 7
        )
        
        #expect(imageTiler.tileHeight == 130)
        #expect(imageTiler.tileWidth == 90)
        #expect(imageTiler.numberOfColumns == 3)
        #expect(imageTiler.numberOfImages == 7)
        
        let expectedWidth = 90 * 3
        #expect(imageTiler.context.width == expectedWidth)
        
        let expectedHeight = 130 * 3
        #expect(imageTiler.context.height == expectedHeight)
    }
    
    @Test
    func coreGraphicsContextParameters() throws {
        let imageTiler = try ImageTiler(
            tileSize: CGSize(
                width: 90,
                height: 130
            ),
            numberOfColumns: 3,
            numberOfImages: 7
        )
        
        #expect(imageTiler.context.bitsPerComponent == 8)
        #expect(imageTiler.context.colorSpace == CGColorSpaceCreateDeviceRGB())
        #expect(imageTiler.context.bitmapInfo.rawValue == CGImageAlphaInfo.premultipliedLast.rawValue)
    }
    
    @Test
    func checkedAppendThrowsForTooLargeImage() throws {
        let imageTiler = try ImageTiler(
            tileSize: CGSize(
                width: 100,
                height: 90
            ),
            numberOfColumns: 3,
            numberOfImages: 7
        )
        
        #expect(throws: ImageTiler.TileError.tileImageIsTooLarge(actualWidth: 200, actualHeight: 210, expectedWidth: 100, expectedHeight: 90)) {
            let tile = CIContext()
                .createCGImage(
                    CIImage(color: .blue),
                    from: CGRect(origin: .zero, size: CGSize(width: 200, height: 210))
                )!
            try imageTiler.checkedAppend(tile: tile)
        }
        
        #expect(throws: ImageTiler.TileError.tileImageIsTooLarge(actualWidth: 100, actualHeight: 210, expectedWidth: 100, expectedHeight: 90)) {
            let tile = CIContext()
                .createCGImage(
                    CIImage(color: .blue),
                    from: CGRect(origin: .zero, size: CGSize(width: 100, height: 210))
                )!
            try imageTiler.checkedAppend(tile: tile)
        }
        
        #expect(throws: ImageTiler.TileError.tileImageIsTooLarge(actualWidth: 200, actualHeight: 90, expectedWidth: 100, expectedHeight: 90)) {
            let tile = CIContext()
                .createCGImage(
                    CIImage(color: .blue),
                    from: CGRect(origin: .zero, size: CGSize(width: 200, height: 90))
                )!
            try imageTiler.checkedAppend(tile: tile)
        }
        
        #expect(throws: Never.self) {
            let tile = CIContext()
                .createCGImage(
                    CIImage(color: .blue),
                    from: CGRect(origin: .zero, size: CGSize(width: 200, height: 210))
                )!
            imageTiler.append(tile: tile)
        }
    }
    
    @Test
    func checkedAppendThrowsForIndexOutOfBounds() throws {
        let imageTiler = try ImageTiler(
            tileSize: CGSize(
                width: 100,
                height: 90
            ),
            numberOfColumns: 3,
            numberOfImages: 1
        )
        
        let tile = CIContext().createCGImage(CIImage(color: .blue), from: CGRect(origin: .zero, size: CGSize(width: 100, height: 90)))!
        try imageTiler.checkedAppend(tile: tile)
        #expect(throws: ImageTiler.TileError.tileIndexOutOfBounds(index: 1, count: 1)) {
            try imageTiler.checkedAppend(tile: tile)
        }
        
        #expect(throws: Never.self) {
            imageTiler.append(tile: tile)
        }
    }
    
    @Test
    func checkedAppendDoesNotThrowForTooSmallImage() throws {
        let imageTiler = try ImageTiler(
            tileSize: CGSize(
                width: 100,
                height: 90
            ),
            numberOfColumns: 3,
            numberOfImages: 7
        )
        
        let tile = CIContext().createCGImage(CIImage(color: .blue), from: CGRect(origin: .zero, size: CGSize(width: 90, height: 80)))!
        #expect(throws: Never.self) {
            try imageTiler.checkedAppend(tile: tile)
        }
    }
    
    @Test
    func append() throws {
        let imageTiler = try ImageTiler(
            tileSize: CGSize(
                width: 100,
                height: 90
            ),
            numberOfColumns: 1,
            numberOfImages: 1
        )
        
        let tile1 = CIContext()
            .createCGImage(
                CIImage(color: .blue),
                from: CGRect(origin: .zero, size: CGSize(width: 90, height: 80))
            )!
        
        try imageTiler.checkedAppend(tile: tile1)
        
        try assertSnapshot(name: "image tiler append") {
            try imageTiler.checkedFinish()
        }
    }
    
    @Test
    func tileArrangesIntoMatrix() throws {
        let imageTiler = try ImageTiler(
            tileSize: CGSize(
                width: 100,
                height: 100
            ),
            numberOfColumns: 2,
            numberOfImages: 3
        )
        
        let tile1 = CIContext()
            .createCGImage(
                CIImage(color: .blue),
                from: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            )!
        
        let tile2 = CIContext()
            .createCGImage(
                CIImage(color: .cyan),
                from: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            )!
        
        let tile3 = CIContext()
            .createCGImage(
                CIImage(color: .yellow),
                from: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            )!
        
        try imageTiler.checkedAppend(tile: tile1)
        try imageTiler.checkedAppend(tile: tile2)
        try imageTiler.checkedAppend(tile: tile3)
        
        try assertSnapshot(name: "image tiler matrix layout") {
            try imageTiler.checkedFinish()
        }
    }
    
    @Test
    func IntMaxArrangesIntoSingleRow() throws {
        let imageTiler = try ImageTiler(
            tileSize: CGSize(
                width: 100,
                height: 100
            ),
            numberOfColumns: Int.max,
            numberOfImages: 3
        )
        
        let tile1 = CIContext()
            .createCGImage(
                CIImage(color: .blue),
                from: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            )!
        
        let tile2 = CIContext()
            .createCGImage(
                CIImage(color: .cyan),
                from: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            )!
        
        let tile3 = CIContext()
            .createCGImage(
                CIImage(color: .yellow),
                from: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            )!
        
        try imageTiler.checkedAppend(tile: tile1)
        try imageTiler.checkedAppend(tile: tile2)
        try imageTiler.checkedAppend(tile: tile3)
        
        try assertSnapshot(name: "image tiler row layout") {
            try imageTiler.checkedFinish()
        }
    }
    
    @Test
    func Int1ArrangesIntoSingleColumn() throws {
        let imageTiler = try ImageTiler(
            tileSize: CGSize(
                width: 100,
                height: 100
            ),
            numberOfColumns: 1,
            numberOfImages: 3
        )
        
        let tile1 = CIContext()
            .createCGImage(
                CIImage(color: .blue),
                from: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            )!
        
        let tile2 = CIContext()
            .createCGImage(
                CIImage(color: .cyan),
                from: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            )!
        
        let tile3 = CIContext()
            .createCGImage(
                CIImage(color: .yellow),
                from: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            )!
        
        try imageTiler.checkedAppend(tile: tile1)
        try imageTiler.checkedAppend(tile: tile2)
        try imageTiler.checkedAppend(tile: tile3)
        
        try assertSnapshot(name: "image tiler column layout") {
            try imageTiler.checkedFinish()
        }
    }
    
    @Test
    func Int0ArrangesIntoSingleColumn() throws {
        let imageTiler = try ImageTiler(
            tileSize: CGSize(
                width: 100,
                height: 100
            ),
            numberOfColumns: 0,
            numberOfImages: 3
        )
        
        let tile1 = CIContext()
            .createCGImage(
                CIImage(color: .blue),
                from: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            )!
        
        let tile2 = CIContext()
            .createCGImage(
                CIImage(color: .cyan),
                from: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            )!
        
        let tile3 = CIContext()
            .createCGImage(
                CIImage(color: .yellow),
                from: CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            )!
        
        try imageTiler.checkedAppend(tile: tile1)
        try imageTiler.checkedAppend(tile: tile2)
        try imageTiler.checkedAppend(tile: tile3)
        
        try assertSnapshot(name: "image tiler zero layout") {
            try imageTiler.checkedFinish()
        }
    }
}

private extension ImageTilerTests {
    func filePath(name: String, directory: String) -> String {
        "\(testsDirectory)/\(directory)/\(name)"
    }
    
    func assertSnapshot(name: String, for operations: () throws -> CGImage) throws {
        let image = try operations()
        let fileName = name.lowercased().replacingOccurrences(of: " ", with: "-")
        #expect(
            try isImageEqual(
                actual: image,
                transformed: filePath(name: "\(fileName).png", directory: "ProducedOutputs"),
                expected: filePath(name: "\(fileName).png", directory: "ExpectedOutputs")
            )
        )
    }
}
