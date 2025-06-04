//
//  SpriteSheetAxis.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

enum SpriteSheetAxis {
    case horizontal(Horizontal)
    case vertical(Vertical)
    
    var kind: Kind {
        switch self {
        case .horizontal: .horizontal
        case .vertical: .vertical
        }
    }
    
    enum Kind {
        case horizontal
        case vertical
    }
}

extension SpriteSheetAxis: Hashable {
    static func == (lhs: SpriteSheetAxis, rhs: SpriteSheetAxis) -> Bool {
        lhs.kind == rhs.kind
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
    }
}
