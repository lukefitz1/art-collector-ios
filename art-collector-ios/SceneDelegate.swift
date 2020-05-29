//
//  SceneDelegate.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/12/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var loginManager = LoginManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // HERE HERE HERE - When you get back to working on auto - login, start here!
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        self.window = UIWindow(windowScene: windowScene)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        if loginManager.isLoggedIn {
//            print("YES loginManager.isLoggedIn")
//
//            let customersViewController = storyboard.instantiateViewController(withIdentifier: "CustomersViewController")
//            let artistsViewController = storyboard.instantiateViewController(withIdentifier: "ArtistsViewController")
//            let giViewController = storyboard.instantiateViewController(withIdentifier: "GeneralInformationViewController")
//            let navigationController = storyboard.instantiateViewController(withIdentifier: "TabBarNavController") as! UITabBarController
//
//            navigationController.viewControllers = [customersViewController, artistsViewController, giViewController]
//            self.window?.rootViewController = navigationController
//            self.window?.makeKeyAndVisible()
//        } else {
//            print("NO loginManager.isLoggedIn")
//
//            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
//
//            navigationController.viewControllers = [initialViewController]
//            self.window?.rootViewController = navigationController
//            self.window?.makeKeyAndVisible()
//        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

