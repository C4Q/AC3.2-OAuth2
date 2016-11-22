//
//  AppDelegate.swift
//  Giterest
//
//  Created by Louis Tur on 11/16/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    GithubOAuthManager.configure(clientID: "b1b766645e040ea3946b", clientSecret: "8b80dd07219f5a0143f19a66e2cd213d2cbd97c2")
    
    do {
      try GithubOAuthManager.shared.requestAuthorization(scopes: [.user, .public_repo])
    }
    catch {
      print("Error: \(error)")
    }
    
    return true
  }
  
  // This delegate method gets hit when we return from Safari, following a successful Authentication/Authorization request
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    
    // This is a bit unnecessary, but we can check the sending app to see what has opened ours. In this case, we check to see if it was Safari
    if let sendingApp = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String {
      if sendingApp == "com.apple.mobilesafari" {
        GithubOAuthManager.shared.requestAuthToken(url: url)
      }
    }
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

