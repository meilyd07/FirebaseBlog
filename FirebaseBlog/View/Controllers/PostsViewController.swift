//
//  FirstViewController.swift
//  FirebaseBlog
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class PostsViewController: UIViewController {
    var ref: DatabaseReference?
    
    var postData = [Post]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        ref = Database.database().reference()
        
        let userId = Auth.auth().currentUser?.uid
        
        if let userId = userId {
            
            ref?.child("posts").child(userId).queryOrdered(byChild: "created").observe(.value, with: { (snapshot) in
                self.postData = []
                
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshot {
                        if let postDict = snap.value as? [String: Any] {
                            if let post = Post(documentId: snap.key, dictionary: postDict) {
                                self.postData.append(post)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            })
        }
    }

}


extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostViewCell
        let post = postData.reversed()[indexPath.row]
        cell?.postText?.text = post.text
        
        let date = Date(timeIntervalSince1970: post.created)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateTime = dateFormatter.string(from: date)
        
        cell?.createdText?.text = dateTime
        return cell!
    }
}

