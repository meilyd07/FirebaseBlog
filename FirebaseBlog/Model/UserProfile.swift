//
//  UserProfile.swift
//  FirebaseBlog
//
//  Created by Admin on 10/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

//import Foundation

enum GenderType: Int {
    case Male = 0
    case Female = 1
}

struct UserProfile {
    private(set) var userId: String
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var gender: GenderType
    private(set) var age: Int
    
    init(userId: String, firstName: String, lastName: String, gender: GenderType, age: Int) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.age = age
    }
}
