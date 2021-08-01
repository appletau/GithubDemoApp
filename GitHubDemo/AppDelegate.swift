//
//  AppDelegate.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/27.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    if #available(iOS 13.0, *) {
    } else {
      window = UIWindow(frame: UIScreen.main.bounds)
      let vcFactory = ViewControllerFactory()
      let navigationController = UINavigationController(rootViewController: vcFactory.createGithubUserViewController())
      window?.rootViewController = navigationController
      window?.makeKeyAndVisible()
    }
    return true
  }
  
  @available(iOS 13.0, *)
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(frame: UIScreen.main.bounds)
    let vcFactory = ViewControllerFactory()
    let navigationController = UINavigationController(rootViewController: vcFactory.createGithubUserViewController())
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    window?.windowScene = windowScene
  }
  
}
