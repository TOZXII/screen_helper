import Flutter
import Foundation
import UIKit

public class ScreenHelperPlugin: NSObject, FlutterPlugin {

  private var screenSizeHelper: ScreenSizeHelper

  override init() {
    self.screenSizeHelper = ScreenSizeHelper()
    super.init()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "screen_helper", binaryMessenger: registrar.messenger())
    let instance = ScreenHelperPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getScreenSizeInInches":
      let screenSizeInInches = self.screenSizeHelper.getScreenSizeInInches()
      result(screenSizeInInches)
    case "getScreenResolution":
      let screenResolution = self.screenSizeHelper.screenSizeInPixels()
      result(screenResolution)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

}
