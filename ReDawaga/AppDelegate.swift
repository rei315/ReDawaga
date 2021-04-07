//
//  AppDelegate.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/29.
//

import UIKit
import ReSwift
import GoogleMaps

let appStore = Store(reducer: appReduce, state: AppState())

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(Constants.GOOGLE_API_KEY)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }


}

