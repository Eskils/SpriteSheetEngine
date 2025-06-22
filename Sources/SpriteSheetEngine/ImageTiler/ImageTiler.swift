//
//  ImageTiler.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

import CoreGraphics

/// Engine used for tiling images as a grid into a larger image.
///  
/// Makes a full size image based on tile size, number of columns and number of images.
/// Then each tile can be appended one by one.
public nonisolated class ImageTiler {
    let context: CGContext
    let numberOfColumns: Int
    let numberOfImages: Int
    let tileWidth: Int
    let tileHeight: Int
    private var currentIndex = 0
    
    /// Constructs a new image tiler by defining a grid from `tileSize`, `numberOfColumns` and `numberOfImages`.
    /// - Throws:
    ///     - ``ImageError`` if the grid could not be made. For example if the grid would have invalid dimensions.
    public init(tileSize: CGSize, numberOfColumns: Int, numberOfImages: Int) throws(ImageError) {
        let actualNumberOfColumns = max(1, min(numberOfImages, numberOfColumns))
        let numberOfRows = Int(ceil(Float(numberOfImages) / Float(actualNumberOfColumns)))
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
        self.numberOfColumns = actualNumberOfColumns
        self.numberOfImages = numberOfImages
    }
    
    /// Arrange a subimage to the next available slot in the grid.
    /// - Parameter tile: Subimage to arrange in the grid.
    /// - Throws:
    ///     - ``TileError`` if the tile is too large or if the grid is full.
    public func checkedAppend(tile: CGImage) throws(TileError) {
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
    
    /// Arrange a subimage to the next available slot in the grid.
    ///
    /// This method fails silently. For guarded arrangement, see ``checkedAppend(tile:)``.
    ///
    /// - Parameter tile: Subimage to arrange in the grid.
    public func append(tile: CGImage) {
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
    
    /// Produce an image from the grid.
    ///
    /// It is safe to call this method multiple times.
    /// This method returns nil upon failure. For guarded finish, see ``checkedFinish()``.
    ///
    /// - Returns: Image of tiled grid as a CoreGraphics image
    public func finish() -> CGImage? {
        context.makeImage()
    }
    
    /// Produce an image from the grid.
    ///
    /// It is safe to call this method multiple times.
    ///
    /// - Returns: Image of tiled grid as a CoreGraphics image
    /// - Throws:
    ///     - ``ImageError`` if the final image could not be made.
    public func checkedFinish() throws(ImageError) -> CGImage {
        guard let image = finish() else {
            throw .cannotMakeImage
        }
        return image
    }
}
