import UIKit
import Flutter
import LocalAuthentication

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let backendChannel = FlutterMethodChannel(
            name: "com.tuonome.test/backend",
            binaryMessenger: controller.binaryMessenger
        )

        let backend = WalletBackend()
        backendChannel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "getFormattedBalance":
                result(backend.getFormattedBalance())
            case "getTransactions":
                result(backend.getTransactions())
            case "getSystemUserName":
                result(backend.getSystemUserName())
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}