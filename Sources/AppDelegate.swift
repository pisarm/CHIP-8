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
    var controller: AppController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow()
        window!.makeKeyAndVisible()

        controller = AppController(withWindow: window!)

        return true
    }

}
