//
//  ImageTiler.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

import CoreGraphics

nonisolated class ImageTiler {
    let context: CGContext
    let numberOfColumns: Int
    let numberOfImages: Int
    let tileWidth: Int
    let tileHeight: Int
    private var currentIndex = 0
    
    init(tileSize: CGSize, numberOfColumns: Int, numberOfImages: Int) throws(ImageError) {
        let actualNumberOfColumns = min(numberOfImages, numberOfColumns)
        let numberOfRows = (numberOfImages + 1) / numberOfColumns
        self.tileWidth = Int(tileSize.width)
        self.tileHeight = Int(tileSize.height)
        let totalImageWidth = actualNumberOfColumns * tileWidth
        let totalImageHeight = numberOfRows * tileHeight
        
        guard let cgContext = CGContext(
            data: nil,
            width: totalImageWidth,
            height: totalImageHeight,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw .cannotMakeCGContext(width: totalImageWidth, height: totalImageHeight)
        }
        
        self.context = cgContext
        self.numberOfColumns = numberOfColumns
        self.numberOfImages = numberOfImages
    }
    
    func checkedAppend(tile: CGImage) throws(TileError) {
        guard tile.width <= tileWidth && tile.height <= tileHeight else {
            throw .tileImageIsTooLarge(
                actualWidth: tile.width,
                actualHeight: tile.height,
                expectedWidth: tileWidth,
                expectedHeight: tileHeight
            )
        }
        
        guard currentIndex < numberOfImages else {
            throw .tileIndexOutOfBounds(index: currentIndex, count: numberOfImages)
        }
        
        append(tile: tile)
    }
    
    func append(tile: CGImage) {
        let column = currentIndex % numberOfColumns
        let row = currentIndex / numberOfColumns
        
        let x = column * tileWidth
        let y = row * tileHeight
        let tileFrame = CGRect(
            x: x,
            y: context.height - y - tileHeight,
            width: tileWidth,
            height: tileHeight
        )
        
        context.draw(tile, in: tileFrame)
        currentIndex += 1
    }
    
    func finish() -> CGImage? {
        context.makeImage()
    }
    
    func checkedFinish() throws(ImageError) -> CGImage {
        guard let image = finish() else {
            throw .cannotMakeImage
        }
        return image
    }
}
