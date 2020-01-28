//
//  AppDelegate.swift
//  Primo
//
//  Created by Jarrett Chen on 12/31/19.
//  Copyright © 2019 Jarrett Chen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = IntroViewController(nibName: "IntroViewController", bundle: nil)
        self.window?.rootViewController = vc
        
        return true
    }


}

