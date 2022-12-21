//
//  SceneDelegate.swift
//  Phone Jail
//
//  Created by David Villegas on 12/8/22.
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
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Get the AppDelegate instance
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // If the app is in the "jail" state, send a jail break notification
        if appDelegate.inJail {
            print("JAIL BREAK")

            // Get the prison object from the app delegate
            var prison = appDelegate.prisonObj

            // Set the status of the prison object to .jailBreak
            prison.status = .jailBreak
            appDelegate.prisonObj = prison

            // Convert the prison object to data
            guard let prisonData = prison.toData() else { return }

            // Encode PhoneJailStatus.jailBreak as data
            guard let statusData = try? JSONEncoder().encode(PhoneJailStatus.jailBreak) else { return }

            // Call the sendData method and pass the encoded data
            PeripheralManagerObj?.sendData(data: statusData)

            // Call the sendToAllReadyPeripherals method and pass the data parameter
            CentralDelegateObj?.sendToAllReadyPeripherals(data: prisonData)
        }
    }



    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

