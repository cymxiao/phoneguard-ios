//
//  AppDelegate.swift
//  phoneguard
//
//  Created by 蔡亚明 on 2018/7/17.
//  Copyright © 2018年 蔡亚明. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
         //UIApplicationStateBackground
        //Add this logic for security reason. If it's stay on black screen, and someone pressed home, some time there's no alarm triggerred.
        let blackScreen = UserDefaults.standard.bool(forKey: "blackScreen")
        if(blackScreen){
            //alarm triggerred.
            //print("blackScreen is true") 
            BaseUIViewController.playSoundFromBGMode(true)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        let blackScreen = UserDefaults.standard.bool(forKey: "blackScreen")
        if(blackScreen){
            //alarm triggerred.
            //print("blackScreen is true")
            BaseUIViewController.playSoundFromBGMode(false)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

