//
//  EmptyImage.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 06/02/2026.
//

import CoreImage

enum EmptyImage {
    static func magenta(of size: CGSize) -> CGImage {
        let size = (size.width.isZero && size.height.isZero) ? CGSize(width: 1, height: 1) : size
        return CIContext().createCGImage(
            CIImage.magenta,
            from: CGRect(origin: .zero, size: size)
        )!
    }
}
