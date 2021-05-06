//
//  AppDelegate.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/29.
//

import UIKit
import ReSwift
import ReSwiftThunk
import GoogleMaps

let thunkMiddleware: Middleware<AppState> = createThunkMiddleware()
let appStore = Store(reducer: appReduce, state: AppState(), middleware: [thunkMiddleware])

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        }                
        
        GMSServices.provideAPIKey(GOOGLE_API_KEY)
             
        Thread.sleep(forTimeInterval: 2.0)
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let isLaunchedBefore = UserDefaults.standard.bool(forKey: "LaunchedBefore")
        if isLaunchedBefore {
            setupMainView()
            return true
        }
                
        setupTutorialView()
        
        return true
    }
    
    private func setupTutorialView() {
        let tutorialVC = TutorialViewController()
        let nav = UINavigationController(rootViewController: tutorialVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
        
    func setupMainView() {
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.2
        window?.layer.add(transition, forKey: kCATransition)
                
        let nav = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

