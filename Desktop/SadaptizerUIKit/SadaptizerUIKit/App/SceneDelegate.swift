//
//  SceneDelegate.swift
//  SadaptizerUIKit
//
//  Created by Jackson  on 10.02.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowScene = scene
        window.rootViewController = try! AnimatingBackgroundController.loadFromStoryboard()
        window.makeKeyAndVisible()
        self.window = window
        
       // window?.windowScene = scene
       // window?.rootViewController = try! ViewController.loadFromStoryboard()
       // window?.makeKeyAndVisible()
        
    }


}

