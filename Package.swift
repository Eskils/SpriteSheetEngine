// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpriteSheetEngine",
    platforms: [.macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SpriteSheetEngine",
            targets: ["SpriteSheetEngine"]
        ),
        .executable(
            name: "mk-sprite-sheet",
            targets: ["MakeSpriteSheet"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SpriteSheetEngine"
        ),
        .executableTarget(
            name: "MakeSpriteSheet",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "SpriteSheetEngineTests",
            dependencies: ["SpriteSheetEngine"]
        ),
    ]
)
