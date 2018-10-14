//
//  SecondViewController.swift
//  FirebaseBlog
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {
    lazy var ref = Database.database().reference()
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBAction func logOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            Helper.clearUserDefaults()
            performSegue(withIdentifier: "logOut", sender: self)
        } catch (let error) {
            Helper.showAlert(title: "sign out failed", message: "Auth sign out failed: \(error)", controller: self)
        }
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        view.endEditing(true)
        let errors = fieldsValidated()
        if errors.count > 0 {
            Helper.showAlert(title: "Validation results:", message: errors.joined(separator: "\n"), controller: self)
        } else {
            let userId = Auth.auth().currentUser?.uid
            if let userId = userId {
                ref = Database.database().reference().child("users").child(userId)
                
                ref.updateChildValues(
                    ["firstname": self.firstNameTextField?.text ?? "",
                     "lastname": self.lastNameTextField?.text ?? "",
                     "gender": self.genderSegmented.selectedSegmentIndex,
                     "age": Int(self.ageTextField?.text ?? "2")!
                    ]
                )
                { (error, ref) in
                    if error != nil {
                        Helper.showAlert(title: "Failure", message: "Error updating profile.", controller: self)
                    } else {
                        Helper.showAlert(title: "Success", message: "Profile updated.", controller: self)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateProfile()
        setGenderSegmentedColors()
        configureTextField()
        configureTapGesture()
    }
    
    private func populateProfile(){
        let userId = Auth.auth().currentUser?.uid
        if let userId = userId {
            ref.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                if let value = value {
                    self.firstNameTextField.text = value["firstname"] as? String ?? ""
                    self.lastNameTextField.text = value["lastname"] as? String ?? ""
                    self.genderSegmented.selectedSegmentIndex = value["gender"] as? Int ?? 0
                    self.ageTextField.text = String((value["age"] as? Int) ?? 0)
                }
                
            }) { (error) in
                Helper.showAlert(title: "Error retrieving user profile", message: "\(error.localizedDescription)", controller: self)
            }
        }
    }
    
    private func configureTextField() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        ageTextField.delegate = self
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
        if firstNameTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty ?? true {
            errors.append("Please enter first name!")
        }
        if lastNameTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty ?? true
        {
            errors.append("Please enter last name!")
        }
        if ageTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty ?? true {
            errors.append("Please enter age!")
        } else {
            let ageNumber = Int(ageTextField.text ?? "")
            if let ageNumber = ageNumber {
                if (ageNumber <= 1) || (ageNumber >= 100) {
                    errors.append("Please enter valid age!")
                }
            }
            else {
                errors.append("Please enter valid age!")
                
            }
        }
        return errors
    }
    
    private func setGenderSegmentedColors() {
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        genderSegmented.setTitleTextAttributes(titleTextAttributes, for: .normal)
        genderSegmented.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }

}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
