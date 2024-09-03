import UIKit
import Flutter
import FlutterWebAuth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

   override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // Handle the custom URL scheme
    if (url.scheme == "philips") {
      // If you're using flutter_web_auth, handle the callback URL
      return FlutterWebAuthPlugin.handleCallback(url.absoluteString)
    }
    return false
  }
}
