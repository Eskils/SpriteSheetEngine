![Sprite Sheet Engine Logo](Resources/sprite-sheet-engine-logo.png)

# Sprite Sheet Engine

Framework and CLI-tool for making sprite sheets from 3D-models

A sprite sheet is a large image containing many smaller images arranged in a grid. The main idea is to speed up load time and compute resources as computers are well optimized for working with images.

While commonly used in games, it might reduce load time for web-applications by opening fewer TCP connections. It can also be used to precompute animations in graphics intense applications.

## Table of contents

- [Installation](#installation)
- [Usage](#usage)
    - [Using the mk-sprite-sheet command line tool](#using-the-mk-sprite-sheet-command)
    - [Using the Sprite Sheet Engine library](#using-the-sprite-sheet-engine-library)
- [Sprite sheet kinds](#sprite-sheet-kinds)
    - [Model3D sprite sheet](#model3d-sprite-sheet)
- [Contributing](#contributing)

## Installation

To use this package in a SwiftPM project, you need to set it up as a package dependency:

```swift
// swift-tools-version:6.1
import PackageDescription

let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(
      url: "https://github.com/Eskils/SpriteSheetEngine", 
      .upToNextMinor(from: "0.1.0") // or `.upToNextMajor
    )
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "SpriteSheetEngine", package: "SpriteSheetEngine")
      ]
    )
  ]
)
```

## Usage

Sprite Sheet Engine is a library and also comes bundled with a command line tool. Please see the section that covers your usecase.

### Using the mk-sprite-sheet command line tool

### Using the Sprite Sheet Engine library

## Sprite Sheet Kinds

### Model3D sprite sheet

## Contributing
