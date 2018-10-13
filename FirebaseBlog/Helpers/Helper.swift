//
//  Helper.swift
//  FirebaseBlog
//
//  Created by Admin on 10/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    static func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    static func showAlert(title: String, message: String, controller: UIViewController)
    {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        controller.present(ac, animated:  true)
    }
    
    static func clearUserDefaults()
    {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "userId")
    }
    
    static func populateUserDefaults(email: String, password: String, userId: String) {
        //write user default settings
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(userId, forKey: "userId")
    }
    
    static func retrieveUserDefaults() -> [String:Any] {
        var dictionary = [String:Any]()
        if let emailText = UserDefaults.standard.value(forKey: "email") as? String {
            dictionary["email"] = emailText
        }
        if let passwordText = UserDefaults.standard.value(forKey: "password") as? String {
            dictionary["password"] = passwordText
        }
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String {
            dictionary["userId"] = userId
        }
        return dictionary
    }
}
