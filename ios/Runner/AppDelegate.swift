import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Google Maps
        GMSServices.provideAPIKey(
            "AIzaSyCY_oVLft-gyfzV_6msJ_H790rH6B-UboI"
        )

        // Local Notifications background/plugin registration
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
            GeneratedPluginRegistrant.register(with: registry)
        }

        // Register Flutter plugins once
        GeneratedPluginRegistrant.register(with: self)

        // Notification delegate
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }

        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}