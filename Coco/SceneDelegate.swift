//
//  SceneDelegate.swift
//  Coco
//
//  Created by Jessi Febria on 05/06/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var splashView: UIView?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let rootViewController: BaseTabBarViewController = BaseTabBarViewController()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        self.window = window
        
        guard let currentActiveNavigationController: UINavigationController = rootViewController.currentActiveNavigationController else {
            return
        }
        
        appCoordinator = AppCoordinator.shared
        appCoordinator?.setNavigationController(currentActiveNavigationController)
        
        rootViewController.baseCoordinator = appCoordinator
        showSplashScreen(over: window)
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

private extension SceneDelegate {
    func showSplashScreen(over window: UIWindow) {
        let logo: UIImageView = UIImageView(image: CocoIcon.splashLogo.image)
        logo.translatesAutoresizingMaskIntoConstraints = false

        window.addSubview(logo)
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: window.topAnchor),
            logo.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            logo.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            logo.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
        
        self.splashView = logo
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismissSplash()
        }
    }

    func dismissSplash() {
        UIView.animate(withDuration: 0.5, animations: {
            self.splashView?.alpha = 0
        }) { _ in
            self.splashView?.removeFromSuperview()
            self.splashView = nil
        }
    }
}
