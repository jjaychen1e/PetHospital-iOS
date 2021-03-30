//
//  SceneDelegate.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/3/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.makeKeyAndVisible()
        
        let rootVC = UIViewController()
        window.rootViewController = rootVC;
        (UIApplication.shared.delegate as! AppDelegate).rootViewController = rootVC
        
        let nvc = UINavigationController()
        nvc.setNavigationBarHidden(true, animated: false)
        (UIApplication.shared.delegate as! AppDelegate).rootNavigationController = nvc
        
        rootVC.addChild(nvc)
        rootVC.view.addSubview(nvc.view)
        nvc.didMove(toParent: rootVC)
        nvc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if LoginHelper.hasCachedLoginStatus() {
            nvc.setViewControllers([StoryboardScene.Main.mainTabBarController.instantiate()], animated: false)
            
            LoginHelper.checkLoginStatus { valid in
                if !valid {
                    nvc.setViewControllers([StoryboardScene.Login.initialScene.instantiate()], animated: true)
                    DispatchQueue.main.async {
                        ToastHelper.show(emoji: "⚠️", title: "身份信息认证失败", subtitle: "请尝试重新登录。")
                    }
                } else {
                    ToastHelper.show(emoji: "🎉", title: "登录成功", subtitle: "使用本地缓存登录成功。欢迎来到宠物医院。")
                }
            }
        } else {
            nvc.setNavigationBarHidden(false, animated: false)
            nvc.setViewControllers([StoryboardScene.Login.initialScene.instantiate()], animated: false)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

