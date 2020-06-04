//
//  SceneDelegate.swift
//
import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        if let windowScene = scene as? UIWindowScene {
            let launchScreen = LaunchVC()
            self.window = UIWindow(windowScene: windowScene)
            self.window!.rootViewController = launchScreen
            self.window!.makeKeyAndVisible()
        }
        
    }

}
