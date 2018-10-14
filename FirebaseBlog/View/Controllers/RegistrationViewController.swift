//
//  RegistrationViewController.swift
//  FirebaseBlog
//
//  Created by Admin on 10/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

class RegistrationViewController: UIViewController {

    lazy var ref: DatabaseReference = Database.database().reference()
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGenderSegmentedColors()
        configureTextField()
        configureTapGesture()
    }
    
    private func setGenderSegmentedColors() {
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        genderSegmented.setTitleTextAttributes(titleTextAttributes, for: .normal)
        genderSegmented.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "logIn", sender: self)
    }
    @IBAction func signUp(_ sender: UIButton) {
        view.endEditing(true)
        let errors = fieldsValidated()
        if errors.count > 0 {
            Helper.showAlert(title: "Validation results:", message: errors.joined(separator: "\n"), controller: self)
        }
        else {
            //create user
            if let email = email.text, let pass = password.text, let firstNameText = firstName.text, let lastNameText = lastName.text, let ageText = age.text {
                Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            Helper.showAlert(title: "Error creation user:", message: "\(error.localizedDescription)", controller: self)
                        }
                    }
                    else {
                        
                        Auth.auth().signIn(withEmail: email, password: pass){
                            (user, error) in
                            if let loggedUser = user {
                                Helper.populateUserDefaults(email: email, password: pass, userId: loggedUser.user.uid)
                                
                                let selectedGender = GenderType(rawValue: self.genderSegmented.selectedSegmentIndex)!
                                let profile = UserProfile(userId: loggedUser.user.uid, firstName: firstNameText, lastName: lastNameText, gender: selectedGender, age: Int(ageText)!)
                                self.populateUserProfile(profile: profile)
                                
                                self.performSegue(withIdentifier: "home", sender: self)
                            } else {
                                if let error = error {
                                    Helper.showAlert(title: "Login failed:", message: "\(error.localizedDescription)", controller: self)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func populateUserProfile(profile: UserProfile)
    {
        ref.child("users").child(profile.userId).setValue(["firstname": profile.firstName, "lastname": profile.lastName, "gender": profile.gender.rawValue, "age": profile.age])
    }
    
    private func configureTextField() {
        firstName.delegate = self
        lastName.delegate = self
        age.delegate = self
        email.delegate = self
        password.delegate = self
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    private func fieldsValidated() -> [String] {
        var errors = [String]()
        if firstName.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty ?? true {
            errors.append("Please enter first name!")
        }
        if lastName.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty ?? true
        {
            errors.append("Please enter last name!")
        }
        if age.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty ?? true {
            errors.append("Please enter age!")
        } else {
            let ageNumber = Int(age.text ?? "")
            if let ageNumber = ageNumber {
                if (ageNumber <= 1) || (ageNumber >= 100) {
                    errors.append("Please enter valid age!")
                }
            }
            else {
                errors.append("Please enter valid age!")
                
            }
        }
        if email.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty ?? true {
            errors.append("Please enter email!")
        }
        else if !Helper.validateEmail(enteredEmail: email.text!){
            errors.append("Please enter valid email!")
        }
        
        if password.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty ?? true {
            errors.append("Please enter password!")
        }
        return errors
    }

}
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == email || textField == password {
            moveTextField(textfield: textField, moveDistance: -100, up: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == email || textField == password {
            moveTextField(textfield: textField, moveDistance: -100, up: false)
        }
    }
    
    func moveTextField(textfield: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
