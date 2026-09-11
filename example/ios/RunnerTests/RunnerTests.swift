import Flutter
import UIKit
import XCTest

@testable import screen_helper

class RunnerTests: XCTestCase {
  func testIPadMini6UsesAn8Point3InchDiagonal() throws {
    for model in ["iPad14,1", "iPad14,2"] {
      let size = try XCTUnwrap(ScreenSizeHelper.sizeInInches(
        modelIdentifier: model, resolution: CGSize(width: 1488, height: 2266)))
      let width = try XCTUnwrap(size["width"])
      let height = try XCTUnwrap(size["height"])
      XCTAssertEqual(sqrt(width * width + height * height), 8.3, accuracy: 0.0001)
    }
    XCTAssertEqual(UIScreen.diagonalInInches(for: "iPad11,1"), 7.9)
  }

  func testUnknownModelsHaveNoPhysicalDimensions() {
    XCTAssertNil(ScreenSizeHelper.sizeInInches(
      modelIdentifier: "unknown-model", resolution: CGSize(width: 900, height: 1200)))
  }

  func testInvalidResolutionHasNoPhysicalDimensions() {
    for width in [CGFloat.zero, -1, .infinity, .nan] {
      XCTAssertNil(ScreenSizeHelper.sizeInInches(
        modelIdentifier: "iPad14,1", resolution: CGSize(width: width, height: 2266)))
    }
  }

  func testResolutionMethodReturnsPositiveDimensions() {
    let plugin = ScreenHelperPlugin()
    let completed = expectation(description: "screen resolution")
    plugin.handle(FlutterMethodCall(methodName: "getScreenResolution", arguments: nil)) { result in
      guard let resolution = result as? [String: CGFloat],
        let width = resolution["width"], let height = resolution["height"]
      else {
        XCTFail("Expected native screen dimensions")
        completed.fulfill()
        return
      }
      XCTAssertGreaterThan(width, 0)
      XCTAssertGreaterThan(height, 0)
      completed.fulfill()
    }
    waitForExpectations(timeout: 1)
  }
}
