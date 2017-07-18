//
//  User.swift
//  linhomes
//
//  Created by Leon on 7/17/17.
//  Copyright © 2017 linhtek. All rights reserved.
//

import Foundation

class User {
    var phone: String
    var name: String
    var password: String
    var status: Int64
    var sync: Int64
    
    init(phone: String) {
        self.phone = phone
        name = ""
        password = ""
        status = 0
        sync = 0
    }
    
    init(phone: String, name: String, password: String, status: Int64, sync: Int64) {
        self.phone = phone
        self.name = name
        self.password = password
        self.status = status
        self.sync = sync
    }
    
    func display(){
        print("Display user ->")
        print("phone: "+self.phone)
        print("name: "+self.name)
        print("password: "+self.password)
        print("status: \(self.status)")
        print("sync: \(self.sync)")
        print("Display user <- ")
    }
}
