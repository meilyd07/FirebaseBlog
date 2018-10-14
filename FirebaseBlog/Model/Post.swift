//
//  Post.swift
//  FirebaseBlog
//
//  Created by Admin on 10/13/18.
//  Copyright © 2018 Admin. All rights reserved.
//
import Foundation

protocol DocumentSerializable {
    init?(documentId: String, dictionary:[String:Any])
}

struct Post {
    private(set) var postId: String
    private(set) var text: String
    private(set) var created: TimeInterval
    
    var dictionary:[String:Any] {
        return [
            "text": text,
            "created": created
        ]
    }
}

extension Post: DocumentSerializable {
    init?(documentId: String, dictionary: [String : Any]) {
        
        guard let created = dictionary["created"] as? TimeInterval
            else {
                return nil
        }
        
        guard let text = dictionary["text"] as? String
            else {
                return nil
        }
        
        self.init(postId: documentId, text: text, created: created)
    }
}
