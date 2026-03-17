import UIKit
import Flutter
import GoogleMaps  // <-- Add Google Maps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Provide your Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyAbmRHOMGItXC6dcajVKckbBpsrygRouts")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
