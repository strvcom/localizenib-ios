//
//  AppDelegate.swift
//  LocalizeNIB
//
//  Created by Jindra Dolezy on 10/11/2016.
//  Copyright (c) 2016 STRV. All rights reserved.
//

import UIKit
import LocalizeNIB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    // If you want to use LocalizeNIB for Main Interface storyboard you need to customize it in the init() method of the AppDelegate
    override init() {
        
        // localizeAll block intercepts all localization attempts
        localizeNIB.localizeAll = { object, stringProvider in
            if let label = object as? UILabel, label.text == "localizeAll" {
                label.text = "Caught by localizeAll block"
                return true
                
            } else {
                print("About to localize \(object)")
                return false
            }
        }
        
        // enable debug mode
        localizeNIB.debugMode = true
        
        // uncomment following line to enable custom stringProvider
        // localizeNIB.stringProvider = { $0.uppercased() }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

}
