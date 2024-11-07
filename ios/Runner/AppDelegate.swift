import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let deviceGuidChannel = FlutterMethodChannel(name: "com.example.flutter_ios_guid_app", binaryMessenger: controller.binaryMessenger)
    
    deviceGuidChannel.setMethodCallHandler { [weak self] (call, result) in
      if call.method == "getDeviceGuid" {
        if let guid = self?.getDeviceUniqueIdentifier() {
          result(guid)
        } else {
          result(FlutterError(code: "UNAVAILABLE",
                              message: "Device GUID not available",
                              details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getDeviceUniqueIdentifier() -> String? {
    var appUUID = IPKeyChainItemWrapper.keyChainItem(forKey: "UniqueGUID") as? String
    
    if let existingUUID = appUUID, !existingUUID.isEmpty {
      // Do nothing if already exists
    } else {
      appUUID = UIDevice.current.identifierForVendor?.uuidString
      IPKeyChainItemWrapper.setKeyChainItem(appUUID, forKey: "UniqueGUID")
    }
    
    return appUUID
  }
}
