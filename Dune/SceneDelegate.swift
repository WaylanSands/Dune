//
//  SceneDelegate.swift
//
import UIKit
import FirebaseAuth
import FirebaseDynamicLinks

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let userActivity = scene.userActivity {
            self.scene(scene, continue: userActivity)
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
        if let windowScene = scene as? UIWindowScene {
            let launchScreen = LaunchVC()
            self.window = UIWindow(windowScene: windowScene)
            self.window!.rootViewController = launchScreen
            self.window!.makeKeyAndVisible()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if let host = url.absoluteURL.host {
                if host == "firebaseauth" {
                    return
                }
            }

            let networkingIndicator = NetworkingProgress()
            networkingIndicator.taskLabel.text = "Fetching"
            UIApplication.shared.windows.last?.addSubview(networkingIndicator)
            DynamicLinks.dynamicLinks().handleUniversalLink(url) { (dynamicLink, error) in
                if error != nil {
                    print("Error with incoming link: \(error!.localizedDescription) ")
                    return
                }

                if let dynamicLink = dynamicLink {
                    print("DynamicLink: \(dynamicLink)")
                    DynamicLinkHandler.handleIncomingLink(dynamicLink) { program in
                        networkingIndicator.removeFromSuperview()
                        if program != nil {
                            self.visitProfile(program: program!, scene: scene)
                        } else {
                            return
                        }
                    }
                }
            }
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            print("Incoming URL (Scene): \(incomingURL)")
            print("Incoming URL (Scene): \(incomingURL.path)")
            print("Incoming URL (Scene): \(incomingURL.absoluteURL)")
            print("Incoming URL (Scene): \(incomingURL.absoluteString)")
            print("Incoming URL (Scene): \(incomingURL.lastPathComponent)")
            
//            if incomingURL.absoluteString != "https://dailyune.page.link/app" {
//                
//                let networkingIndicator = NetworkingProgress()
//                networkingIndicator.taskLabel.text = "Fetching"
//                UIApplication.shared.windows.last?.addSubview(networkingIndicator)
//                
//                DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
//                    if error != nil {
//                        print("Error with incoming link: \(error!.localizedDescription) ")
//                        return
//                    }
//                    if let dynamicLink = dynamicLink {
//                        print("DynamicLink: \(dynamicLink)")
//                        DynamicLinkHandler.handleIncomingLink(dynamicLink) { program in
//                            networkingIndicator.removeFromSuperview()
//                            if program != nil {
//                                self.visitProfile(program: program!, scene: scene)
//                            } else {
//                                return
//                            }
//                        }
//                    }
//                }
//            }
        }
    }
    
    
    func visitProfile(program: Program, scene: UIScene) {
        if CurrentProgram.programsIDs().contains(program.ID) {
            duneTabBar.visit(screen: .account)
//            let tabBar = MainTabController()
//            tabBar.selectedIndex = 4
//            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
//            sceneDelegate.window?.rootViewController = tabBar
        } else {
            duneTabBar.visit(screen: .search)
            duneTabBar.visitChannel(program)
            
//            navigateTo(program: program)
        }
    }
    
    func navigateTo(program: Program) {
        let tabBar = MainTabController()
        tabBar.selectedIndex = 1
        let searchNav = tabBar.selectedViewController as! UINavigationController
        let searchVC = searchNav.viewControllers[0] as! SearchVC
        searchVC.programToPush = program
        self.window?.rootViewController = tabBar
    }
}
