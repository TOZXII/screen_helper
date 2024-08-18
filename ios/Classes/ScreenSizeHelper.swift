import UIKit

public class ScreenSizeHelper {

  private var deviceInfo: [String: [String: Any]]

  init(deviceInfo: [String: [String: Any]] = [:]) {
    self.deviceInfo = deviceInfo
  }

  public func getScreenPPI() -> Double? {
    // Get the device's diagonal size in pixels
    guard let diagonalPixels = self.screenDiagonalSizeInPixels() else { return nil }

    // Get the device's diagonal size in inches
    guard let diagonalInches = self.getDeviceDiagonalSize() else { return nil }

    let ppi = Double(diagonalPixels) / Double(diagonalInches)

    return ppi
  }

  public func screenDiagonalSizeInPixels() -> Int? {
    // Screen size in pixels
    let screenSize = UIScreen.main.bounds.size
    // Screen scale
    let scale = UIScreen.main.scale
    // Screen width in pixels
    let widthPixels = screenSize.width * scale
    // Screen height in pixels
    let heightPixels = screenSize.height * scale
    return Int(sqrt(pow(widthPixels, 2) + pow(heightPixels, 2)))
  }

  public func getDeviceDiagonalSize() -> CGFloat? {
    let deviceModel: String

    #if targetEnvironment(simulator)
      // Simulator-specific code
      if let simulatorModelIdentifier = ProcessInfo.processInfo.environment[
        "SIMULATOR_MODEL_IDENTIFIER"]
      {
        deviceModel = simulatorModelIdentifier
      } else {
        deviceModel = UIDevice.current.modelName  // Fallback, though unlikely needed
      }
    #else
      // Real device code
      deviceModel = UIDevice.current.modelName
    #endif

    // Print the device model
    print("Device Model: \(deviceModel)")

    if let deviceData = deviceInfo[deviceModel],
      let screenSize = deviceData["screen_size"] as? CGFloat
    {
      return screenSize
    }

    return nil
  }

  public func getScreenWidthSizeInInches() -> CGFloat? {
    let screenSize = UIScreen.main.bounds.size
    let scale = UIScreen.main.scale
    let widthPixels = screenSize.width * scale
    guard let ppi = getScreenPPI() else {
      print("Error: Unable to retrieve PPI")
      return nil
    }

    return widthPixels / ppi
  }

  public func getScreenHeightSizeInInches() -> CGFloat? {
    let screenSize = UIScreen.main.bounds.size
    let scale = UIScreen.main.scale
    let heightPixels = screenSize.height * scale
    guard let ppi = getScreenPPI() else {
      print("Error: Unable to retrieve PPI")
      return nil
    }

    return heightPixels / ppi
  }

  public func getScreenRealWidthInPixels() -> Int? {

    let screenSize = UIScreen.main.bounds.size
    let scale = UIScreen.main.scale
    return Int(screenSize.width * scale)
  }

  public func getScreenRealHeightInPixels() -> Int? {
    let screenSize = UIScreen.main.bounds.size
    let scale = UIScreen.main.scale
    return Int(screenSize.height * scale)
  }

  public func loadDeviceInfo() {
    guard
      let url = Bundle(for: type(of: self)).url(forResource: "device_info", withExtension: "json")
    else {
      print("device_info.json not found in plugin bundle")
      return
    }

    do {
      let data = try Data(contentsOf: url)
      let json =
        try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Any]]
      self.deviceInfo = json ?? [:]

    } catch let parsingError {
      print("Error parsing JSON: \(parsingError)")
    }
  }
}

extension UIDevice {
  public var modelName: String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
  }
}
