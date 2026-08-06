import Flutter
import UIKit
import GoogleMaps
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }

        GMSServices.provideAPIKey("AIzaSyCY_oVLft-gyfzV_6msJ_H790rH6B-UboI")

        GeneratedPluginRegistrant.register(with: self)

        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }

    func didInitializeImplicitFlutterEngine(
        _ engineBridge: FlutterImplicitEngineBridge
    ) {
        GeneratedPluginRegistrant.register(
            with: engineBridge.pluginRegistry
        )
    }
}