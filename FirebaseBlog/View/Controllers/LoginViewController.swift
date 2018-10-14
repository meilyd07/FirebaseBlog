//
//  LoginViewController.swift
//  FirebaseBlog
//
//  Created by Admin on 10/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signUpButtonTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "signUp", sender: self)
    }
    
    
    @IBAction func signInButtonTap(_ sender: UIButton) {
        if let email = emailTextField.text, let pass = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: pass){
                (user, error) in
                if let loggedUser = user {
                    Helper.populateUserDefaults(email: email, password: pass, userId: loggedUser.user.uid)
                    self.performSegue(withIdentifier: "home", sender: self)
                } else {
                    if let error = error {
                        Helper.showAlert(title: "Login failed:", message: "\(error.localizedDescription)", controller: self)
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    private func configureTextField() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
