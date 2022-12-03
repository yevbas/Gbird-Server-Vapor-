//
//  AppDelegate.swift
//  EasyReader
//
//  Created by Jackson  on 30/08/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ImageHunterScreen()
        window?.makeKeyAndVisible()

        return true
    }

}

