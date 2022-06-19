//
//  AppDelegate.swift
//  MultithreadingTask
//
//  Created by Jackson  on 30.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let propertyService = PropertyService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        for i in 0...100 {
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                for j in 0...10000 {
                    //print("\n\n")
                    print("Queue[\(i)], Operation[\(j)]")
                    self.propertyService.mutateData()
                    //print("\n\n")

                }
            }
        }
        return true
    }


}

