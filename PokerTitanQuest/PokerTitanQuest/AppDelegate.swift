//
//  AppDelegate.swift
//  PokerTitanQuest
//
//  Created by PokerTitanQuest on 2024/11/5.
//

import UIKit
import Adjust

@main
class AppDelegate: UIResponder, UIApplicationDelegate, AdjustDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let token = UIViewController.titanAdToken()
        let environment = ADJEnvironmentProduction
        let myAdjustConfig = ADJConfig(
               appToken: token,
               environment: environment)
        myAdjustConfig?.delegate = self
        myAdjustConfig?.logLevel = ADJLogLevelVerbose
        Adjust.appDidLaunch(myAdjustConfig)
        
        return true
    }
    
    func adjustEventTrackingSucceeded(_ eventSuccessResponseData: ADJEventSuccess?) {
        print("adjustEventTrackingSucceeded")
    }
    
    func adjustEventTrackingFailed(_ eventFailureResponseData: ADJEventFailure?) {
        print("adjustEventTrackingFailed")
    }
    
    func adjustAttributionChanged(_ attribution: ADJAttribution?) {
        print("adid\(attribution?.adid ?? "")")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

