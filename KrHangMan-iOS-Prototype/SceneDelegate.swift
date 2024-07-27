//
//  SceneDelegate.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 김태성 on 2022/12/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
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
        print("sceneWillResignActive Start")
        guard let updateScore = AppManager.useUserDataService().getUserScore() else {
            return
        }
        guard let userName = AppManager.useUserDataService().getUserName() else {
            return
        }
        guard let isRankUpdate = AppManager.useUserDataService().getIsRankUpdate() else {
            return
        }
        
        if(isRankUpdate) {
            let parameter = FetchRankParameter(count: updateScore)
            let urlString = Constant.getURLString(.PATCH_RANK, AppManager.useUserDataService().getUserName())
            AppManager.useAPIService().requestPatch(urlString: urlString, parameter: parameter) {
                statusCode in
                guard let statusCode = statusCode else {
                    return
                }
                if(statusCode == 200) {
                    AppManager.useUserDataService().setData(isRankUpdate: false)
                }
            }
        }
       
        AppManager.useUserDataService().saveData()
        print("sceneWillResignActive End")
    }
    
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        CoreDataManager.share.saveContext()
    }
    
    
}

