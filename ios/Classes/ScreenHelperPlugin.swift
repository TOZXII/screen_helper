import Flutter
import Foundation
import UIKit

public class ScreenHelperPlugin: NSObject, FlutterPlugin {

  private var screenSizeHelper: ScreenSizeHelper

  override init() {
    self.screenSizeHelper = ScreenSizeHelper()
    super.init()
    self.screenSizeHelper.loadDeviceInfo()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "screen_helper", binaryMessenger: registrar.messenger())
    let instance = ScreenHelperPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getScreenPPI":
      result(self.screenSizeHelper.getScreenPPI())
    case "getScreenDiagonalSizeInInches":
      result(self.screenSizeHelper.getDeviceDiagonalSize())
    case "getScreenWidthSizeInInches":
      result(self.screenSizeHelper.getScreenWidthSizeInInches())
    case "getScreenHeightSizeInInches":
      result(self.screenSizeHelper.getScreenHeightSizeInInches())
    case "getScreenRealWidthInPixels":
      result(self.screenSizeHelper.getScreenRealWidthInPixels())
    case "getScreenRealHeightInPixels":
      result(self.screenSizeHelper.getScreenRealHeightInPixels())
    case "screenDiagonalSizeInPixels":
      result(self.screenSizeHelper.screenDiagonalSizeInPixels())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
