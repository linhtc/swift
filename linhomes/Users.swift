//
//  Users.swift
//  linhomes
//
//  Created by Leon on 7/17/17.
//  Copyright © 2017 linhtek. All rights reserved.
//

import Foundation

class Users {
    let id: Int64?
    var name: String
    var phone: String
    var address: String
    
    init(id: Int64) {
        self.id = id
        name = ""
        phone = ""
        address = ""
    }
    
    init(id: Int64, name: String, phone: String, address: String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.address = address
    }
}
