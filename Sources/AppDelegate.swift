//
//  AppDelegate.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 15/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK: Properties
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow()
        window!.rootViewController = ViewController()
        window!.makeKeyAndVisible()

        return true
    }
}
