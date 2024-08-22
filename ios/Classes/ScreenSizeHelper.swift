import UIKit

public class ScreenSizeHelper {

  // function to get real screen size in inches (width and height)
  func getScreenSizeInInches() -> [String: CGFloat] {
    let screenSize = UIScreen.dimensionInInches
    let screenWidthInInc = screenSize?.width
    let screenHeightInInc = screenSize?.height
    return ["width": screenWidthInInc ?? 0, "height": screenHeightInInc ?? 0]
  }

  // function to get screen resolution in pixels (width and height)
  func screenSizeInPixels() -> [String: CGFloat] {
    let screenSize = UIScreen.main.nativeBounds.size
    let screenWidthInPixels = screenSize.width
    let screenHeightInPixels = screenSize.height
    return ["width": screenWidthInPixels, "height": screenHeightInPixels]
  }

}
