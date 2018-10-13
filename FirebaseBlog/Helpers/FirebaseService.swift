//
//  FirebaseService.swift
//  FirebaseBlog
//
//  Created by Admin on 10/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FireStoreService {
    static let shared = FireStoreService()
    
    lazy var ref: DatabaseReference = Database.database().reference()
    
    
    
}
