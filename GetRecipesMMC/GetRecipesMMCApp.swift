//
//  GetRecipesMMCApp.swift
//  GetRecipesMMC
//
//  Created by Vardges Gasparyan on 2024-07-08.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      registerForPushNotifications()
    return true
  }
    
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // 1. Check to see if permission is granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

@main
struct GetRecipesMMCApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var webService = WebService()
    @StateObject private var authServices = AuthServices()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(homeViewModel)
                .environmentObject(webService)
                .environmentObject(authServices)
                .preferredColorScheme(.light)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
}
