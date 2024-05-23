//
//  PreDayApp.swift
//  PreDay
//
//  Created by Tom Herrmann on 12.05.24.
//

import SwiftUI
import FirebaseCore
/*
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
*/
@main
struct PreDayApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
