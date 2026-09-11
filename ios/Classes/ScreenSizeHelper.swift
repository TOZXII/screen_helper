import UIKit

public class ScreenSizeHelper {

  // function to get real screen size in inches (width and height)
  func getScreenSizeInInches() -> [String: CGFloat]? {
    return Self.sizeInInches(
      modelIdentifier: UIDevice.modelIdentifier,
      resolution: UIScreen.main.nativeBounds.size)
  }

  static func sizeInInches(modelIdentifier: String, resolution: CGSize) -> [String: CGFloat]? {
    guard let diagonal = UIScreen.diagonalInInches(for: modelIdentifier),
      resolution.width.isFinite, resolution.height.isFinite,
      resolution.width > 0, resolution.height > 0
    else { return nil }
    let ratio = resolution.width / resolution.height
    let height = diagonal / sqrt(ratio * ratio + 1)
    return ["width": ratio * height, "height": height]
  }

  // function to get screen resolution in pixels (width and height)
  func screenSizeInPixels() -> [String: CGFloat] {
    let screenSize = UIScreen.main.nativeBounds.size
    let screenWidthInPixels = screenSize.width
    let screenHeightInPixels = screenSize.height
    return ["width": screenWidthInPixels, "height": screenHeightInPixels]
  }

}
