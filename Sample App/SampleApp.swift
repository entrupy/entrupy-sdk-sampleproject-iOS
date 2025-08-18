//
//  Sneaker_Authentication_DemoApp.swift
//  Sneaker Authentication Demo
//
//  Created by Dharini Raghavan on 6/17/22.
//

import SwiftUI
import EntrupySDK


@main
struct Sneaker_Authentication_DemoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: LoginViewModel())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    static private(set) var instance: AppDelegate! = nil
    var partnerAccessToken: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        AppDelegate.instance = self
        
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        //Call this to handle EntrupySDK upload or download events that occured while the app was in the suspended state
        EntrupyApp.sharedInstance().interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler:completionHandler)
    }
}
