import Testing
import CoreGraphics
import CoreImage
@testable import SpriteSheetEngine

struct SpriteSheetEngineTests {
    @Test
    @MainActor
    func spriteSheetCallsSetupBeforeMakingImages() async throws {
        var didSetup = false
        var didMakeImage = false
        let renderer = MockSpriteSheetRenderer { _ in
            #expect(!didMakeImage)
            #expect(!didSetup)
            didSetup = true
        } makeImageHandler: { _ in
            #expect(didSetup)
            didMakeImage = true
            return CIContext().createCGImage(CIImage.blue, from: CGRect(x: 0, y: 0, width: 100, height: 100))!
        }

        let description = MockSpriteSheetDescription(
            operations: [.operation]
        )
        
        let engine = SpriteSheetEngine(renderer: renderer, description: description)
        
        #expect(!didMakeImage)
        #expect(!didSetup)
        
        _ = try await engine.spriteSheet()
        
        #expect(didMakeImage)
        #expect(didSetup)
    }
    
    @Test
    @MainActor
    func spriteSheetCallsMakeImageForEachOperation() async throws {
        var imageCount = 0
        let expectedImageCount = Int.random(in: 4..<20)
        let renderer = MockSpriteSheetRenderer { _ in
        } makeImageHandler: { _ in
            imageCount += 1
            return CIContext().createCGImage(CIImage.blue, from: CGRect(x: 0, y: 0, width: 100, height: 100))!
        }

        let description = MockSpriteSheetDescription(
            operations: [MockSpriteSheetOperation](repeating: .operation, count: expectedImageCount)
        )
        
        let engine = SpriteSheetEngine(renderer: renderer, description: description)
        
        _ = try await engine.spriteSheet()
        
        #expect(imageCount == expectedImageCount)
    }
}
