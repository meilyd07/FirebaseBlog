//
//  AppCoordinator.swift
//  FirebaseBlog
//
//  Created by Admin on 10/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AppCoordinator: Coordinator
{
    var window: UIWindow
    
    init(window: UIWindow)
    {
        self.window = window
    }
    
    func start()
    {
        switchViewController()
    }
    
    func switchViewController() {
        //check if user defaults populated
        let dict = Helper.retrieveUserDefaults()
        
        if let email = (dict["email"] as? String), let password = (dict["password"] as? String) {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                // try to sign in with credentials from user defaults
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if error != nil {
                    //instantiate LOGIN SCREEN TO DO
                    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.window.rootViewController = loginViewController
                    self.window.makeKeyAndVisible()
                }
                else {
                    //instantiate TAB SCREEN for logged user
                    let tabViewController = storyboard.instantiateViewController(withIdentifier: "tabViewController") as! UITabBarController
                    self.window.rootViewController = tabViewController
                    self.window.makeKeyAndVisible()
                }
            }
        } else {
            //instantiate REGISTRATION SCREEN
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let registrationViewController = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
            self.window.rootViewController = registrationViewController
            self.window.makeKeyAndVisible()
        }
    }
    
    
    
    
}
