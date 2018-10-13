//
//  AddRecordViewController.swift
//  FirebaseBlog
//
//  Created by Admin on 10/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddRecordViewController: UIViewController, UITextViewDelegate {

    lazy var ref = Database.database().reference()
    
    @IBAction func addRecord(_ sender: Any) {
        if textView.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty ?? true {
            Helper.showAlert(title: "Empty post", message: "Please enter text!", controller: self)
        }
        else {
            let dict = Helper.retrieveUserDefaults()
            
            if let userId = dict["userId"] as? String {
                
                let timestamp = NSDate().timeIntervalSince1970
                
                ref.child("posts").child(userId).childByAutoId().setValue(["text": textView?.text ?? "[empty post]", "created": timestamp])
            }
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        self.navigationItem.title = "Post"
     }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 100
    }
}
