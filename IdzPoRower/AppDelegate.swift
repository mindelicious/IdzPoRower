//
//  AppDelegate.swift
//  IdzPoRower
//
//  Created by Mateusz Danieluk on 10/11/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        return true
    }


}

