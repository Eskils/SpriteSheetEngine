![Sprite Sheet Engine Logo](Resources/sprite-sheet-engine-logo.png)

# Sprite Sheet Engine

Framework and CLI-tool for making sprite sheets from 3D-models

A sprite sheet is a large image containing many smaller images arranged in a grid. The main idea is to speed up load time and compute resources as computers are well optimized for working with images.

While commonly used in games, it also has applications in other domains. Sprite sheets may reduce load time for web-applications by opening fewer TCP connections. It can also be used to precompute animations in graphics intense applications.

![A simple sprite sheet with a static cylinder and a cone that changes color](Tests/SpriteSheetEngineTests/ExpectedOutputs/model-sprite-sheet-4-material.png)

## Table of contents

- [Installation](#installation)
- [Usage](#usage)
    - [Using the mk-sprite-sheet command line tool](#using-the-mk-sprite-sheet-command-line-tool)
    - [Using the Sprite Sheet Engine library](#using-the-sprite-sheet-engine-library)
- [Writing Sprite Sheet Descriptions](#writing-sprite-sheet-descriptions)
    - [Export Settings](#export-settings)
    - [Number of columns](#number-of-columns)
    - [Model SpriteSheetDescription](#model-spritesheetdescription)
- [Making a custom sprite sheet engine](#making-a-custom-sprite-sheet-engine)
    - [Define a new kind of SpriteSheetDescription](#define-a-new-kind-of-spritesheetdescription)
    - [Implement your sprite sheet renderer](#implement-your-sprite-sheet-renderer)
    - [Using SpriteSheetEngine with a custom renderer](#using-spritesheetengine-with-a-custom-renderer)
- [Testing](#testing)
- [3D model support](#3d-model-support)
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

Sprite Sheet Engine is a macOS library that also comes bundled with a command line tool. Please see the section that covers your usecase.

The main way of making a sprite sheet is through a sprite sheet description. You can define such a description in Swift or a parseable file format such as JSON.

### Using the mk-sprite-sheet command line tool

The `mk-sprite-sheet` command line tool provides a way to make sprite sheets as part of your application build pipeline or manually through the terminal.

#### Usage: 
```
mk-sprite-sheet <subcommand>
```

The currently supported sprite sheet types are:

| Subcommand | Description | Documentation |
|-|-|-|
| model | Make sprite sheet from a 3D model. | [Documentation](#usage-of-model) |


#### Usage of `model`
```
mk-sprite-sheet model <input> <output>
```

| Argument | Description | Support |
|-|-|-|
| `input` | Path to model sprite sheet description file | json |
| `output` | Path to output sprite sheet (image) | png, jpeg |

The output format of the sprite sheet image is defined in the sprite sheet description under `export.format`

For supported 3D models, see [3D model support](#3d-model-support).

### Using the Sprite Sheet Engine library

The SpriteSheetEngine library for macOS allows you to integrate sprite sheet creation into your own app. 

You may define a sprite sheet description as a Swift file or JSON data.

#### Using ModelSpriteSheetEngine

The easiest way to get started is by using ModelSpriteSheetEngine to make a sprite sheet from 3D-models.

For supported 3D models, see [3D model support](#3d-model-support).

You start by initializing an engine using either a `SpriteSheetDescription.Model` or a url/data to a sprite sheet description in JSON format. The initializer runs on the MainAction due to isolation needed to load the 3D-model.

You can then produce the sprite sheet as a Core Graphics image by calling the async method `spriteSheet()`, or export it as a png or jpeg by calling `export(to:)`

_Examples:_

Making a sprite sheet from description in Swift.
```swift
let model = try await Entity.load(...)
let description = SpriteSheetDescription.Model(
    model: .realityKit(model),
    operations: [ModelOperation] = [...],
    numberOfColumns = 4,
)
let engine = ModelSpriteSheetEngine(description: description)
let image = try await engine.spriteSheet()
```

Imporing and exporting from/to file
```swift
let inputFileURL = URL(filePath: ...)
let outputFileURL = URL(filePath: ...)
let engine = ModelSpriteSheetEngine(
  url: inputFileURL,
  type: .json,
  relativeTo: inputFileURL.deletingLastPathComponent()
  // relativeTo gives the base for where to locate the 3D-model
  // if its file url is relative.
)
try await engine.export(to: outputFileURL)
```

## Writing Sprite Sheet Descriptions

Sprite sheet descriptions are what describe how to make the sprite sheet. It contains information such as what 3D-model to load, what operations to perform for each tile and how to layout the produced tiles.

Every sprite sheet descripion has the following configurable properties:

| Property | Type | Description |
|-|-|-|
| operations | [SpriteSheetOperation] | Operations used to produce the tiles. |
| numberOfColumns | Int | The number of tiles to place next to each other horizontally before expanding the sprite sheet verically. Default is `Int.max` |
| export | ExportSettings | Collection of properties used to describe how to export the sprite sheet. |


Enlisted are the possible kinds of sprite sheet description:
| Kind | Description | Documentation |
|-|-|-|
| `SpriteSheetDescription.Model` | Describes how to turn your 3D model into a sprite sheet | [Documentation](#model-spritesheetdescription)

The coming subchapters will go in-depth on the properties common to all sprite sheet descriptions, then the various kinds of sprite sheet descriptions will be discussed.

### Export Settings

A common configuration is how the sprite sheet should be exported. You can configure the export format and tile size, which in turn determines how large the sprite sheet will be.

The tile size is determined by the `size` property. A size of zero is invalid and the default size is 128x128.

The export format is determined by `format`. Supported export formats are JPEG and PNG.

### Number of columns

You will also need to specify how to layout the tiles in a grid. This is determined by specifying how many columns are sufficient.

The number of columns give a number for how many tiles are in a row, or in other words, how many tiles to place next to each other horizontally before expanding the sprite sheet verically.

_Examples:_

| Number of columns | Layout |
|-|-|
|1|![Layout 1x3](Tests/SpriteSheetEngineTests/ExpectedOutputs/image-tiler-column-layout.png)|
|2|![Layout 2x2](Tests/SpriteSheetEngineTests/ExpectedOutputs/image-tiler-matrix-layout.png)|
|3|![Layout 3x1](Tests/SpriteSheetEngineTests/ExpectedOutputs/image-tiler-row-layout.png)|

### Model SpriteSheetDescription

This kind of description describes how to turn your 3D model into a sprite sheet. It can be written in Swift and JSON. Below are examples and reference documentation.

In addition to the properties common to all sprite sheet descriptions, `Model` also has these:

| Property | Type | Description |
|-|-|-|
| model | ModelKind | The kind of 3D Model to use for rendering |
| camera | CameraSettings | Collection of properties that affect the camera in the scene. |

SpriteSheetOperation is bound to `ModelOperation`, which allows the following operations:

- **Transform**: Apply transform to a node in the 3D-model
- **Material**: Change color of a node in the 3D-model
- **None**: Produce an image where the model remains unchanged

#### Swift interface

The Swift interface is defined from `SpriteSheetDescription.Model`.

_Examples:_

The following example will produce a 2x2 grid where the cone has a different color in each tile.

```swift
let model = try await MainActor.run {
    try Entity.load(contentsOf: URL(filePath: modelPath))
}
let description = SpriteSheetDescription.Model(
    model: .realityKit(model),
    operations: [
        .material(ModelOperation.Material(
          nodeID: "Cone", 
          color: CGColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1)
          )
        ),
        .material(ModelOperation.Material(
          nodeID: "Cone", 
          color: CGColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 1)
          )
        ),
        .material(ModelOperation.Material(
          nodeID: "Cone", 
          color: CGColor(red: 0.6, green: 0.6, blue: 0.8, alpha: 1)
          )
        ),
        .material(ModelOperation.Material(
          nodeID: "Cone", 
          color: CGColor(red: 0.8, green: 0.6, blue: 0.8, alpha: 1)
          )
        )
    ],
    numberOfColumns: 2
)
```

This example sets a custom tile size, export format, background color, camera transform and 

```swift
let model = try await MainActor.run {
    try Entity.load(contentsOf: URL(filePath: modelPath))
}
let description = SpriteSheetDescription.Model(
    model: .realityKit(model),
    camera: CameraSettings(
      // Position camera 5 meters back from origin on the z-axis
      transform: simd_float4x4(
          rows: [
            SIMD4(1, 0, 0, 0),
            SIMD4(0, 1, 0, 0),
            SIMD4(0, 0, 1, 5),
            SIMD4(0, 0, 0, 1),
          ]
      ),
      background: .color(
        CGColor(
          red: 170.0 / 255,
          green: 187.0 / 255,
          blue: 204.0 / 255,
          alpha: 1
        )
      )
    ),
    operations: [
        .transform(ModelOperation.Transform(
          nodeID: "Cone", 
          matrix: simd_float4x4(0.2)
          )
        ),
        .transform(ModelOperation.Transform(
          nodeID: "Cone", 
          color: simd_float4x4(0.3)
          )
        )
    ],
    export: ExportSettings(
      size: CGSize(width: 50, height: 50),
      format: .jpeg
    )
)
```

For a full reference, please build documentation in an editor like Xcode.

#### JSON interface

The JSON interface is defined from `SpriteSheetDescription.ModelDTO`.

Please use the following schema as a reference:

```json
{
  "model": "file url as string",
  "camera": {
    "background": "#AABBCC" | "transparent",
    "projection": "perspective" | "orthographic",
    "transform": [
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 2,
      0, 0, 0, 1
    ],
  },
  "operations": [
    {
      "type": "transform",
      "nodeID": "cylinder",
      "matrix": [
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
      ]
    },
    {
      "type": "material",
      "nodeID": "cone",
      "color": "#AABBCC" | "transparent"
    },
    {
      "type": "none"
    }
  ],
  "numberOfColumns": 4,
  "export": {
    "size": [100, 100],
    "kind": "image",
    "format": "jpeg" | "png"
  }
}
```

_Example:_

```json
{
  "model": "\(usdModelPath)",
  "camera": {
    "background": "#aabbcc",
    "projection": "orthographic",
    "transform": [
      1,0,0,0,
      0,1,0,0,
      0,0,1,4,
      0,0,0,1
    ]
  },
  "operations": [
    {
      "type": "material",
      "nodeID": "cone",
      "color": "#00BBCC"
    },
    {
      "type": "material",
      "nodeID": "cone",
      "color": "#22BBCC"
    },
    {
      "type": "material",
      "nodeID": "cone",
      "color": "#44BBCC"
    },
    {
      "type": "material",
      "nodeID": "cone",
      "color": "#66BBCC"
    }
  ],
  "numberOfColumns": 2,
  "export": {
    "size": [80, 80],
    "kind": "image",
    "format": "jpeg"
  }
}
```

## Making a custom sprite sheet engine

Aside from the built-in ModelSpriteSheetEngine, you can use SpriteSheetEngine to write your own implementation for generating sprite sheet tiles.

### Define a new kind of SpriteSheetDescription

You start by defining an entity structure for your engine’s sprite sheet description. This description needs to have all the common properties of sprite sheet descriptions by implementing `SpriteSheetDescribable`.

Keep in mind that the size of each tile is stored in `export.size`.

You also need to make an entity structure for the supported tile operations in your engine. This structure needs to implement `SpriteSheetOperation`.

See implementations of `ModelOperation` and `SpriteSheetDescription.Model` for reference.

### Implement your sprite sheet renderer

When you have a sprite sheet description, you can implement a renderer to make tile images.

You implement `SpriteSheetRenderer` by writing two methods:

- `setup(description: Description) async throws` Configure the rendering environment 
- `makeImage(for operation: Description.Operation) async throws -> CGImage` Make the image described by the given operation.

The setup method will be called by SpriteSheetEngine every time a new sprite sheet is made.
If your setup work only needs to happen once, it can be done in the initializer. Similarly, if your setup needs to happen on a particular actor—such as the main actor—it is better suiter for the renderer’s initializer.

The makeImage method will be called for each operation defined in the sprite sheet description. After rendering the image, any work necessary to revert the changes in the rendering environment should be performed before returning the image. See ``RealityKitModelRenderer.perform(operation:)`` for an example of resetting the performed operation.

### Using SpriteSheetEngine with a custom renderer

When a renderer is in place, you can provide it to SpriteSheetEngine. Please see implementations in ModelSpriteSheetEngine for reference.

_Example:_
```swift
let description = MySpriteSheetDescription(...)
let renderer = MySpriteSheetRenderer(description: description)
let engine = SpriteSheetEngine(renderer: renderer, description: description)
let spriteSheet = try await engine.spriteSheet()
```

## Testing

Many of the tests work by checking if the image produced by the code look the same to expected output images. Expected output images are found in _Tests/ExpectedOutputs_. When these snapshot tests are run, the produced images are funneled into _Tests/ProducedOutputs_.

3D-Models used for testing are located in _Tests/TestAssets_.

When `mk-sprite-sheet` is run from Xcode, it uses the project direcrory as a working directory and uses the description located at _Tests/TestAssets/cylinder-and-cone-sheet-descripion.json_. The produced image is put to _Tests/ProducedOutputs/mk-sprite-sheet-output.png_

## 3D model support

Supported 3D model types are currently limited to Universal Scene Description (usdc, usdz). You can use Blender or Reality Converter to create a usdc file from other 3D file formats.

## Contributing

Contributions are welcome and encouraged. Feel free to check out the project, submit issues and code patches.

Your feedback is of great value. Open an issue and let me know if you encounter any difficulties or what features you are missing.