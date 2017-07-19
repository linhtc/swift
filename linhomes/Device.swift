//
//  Device.swift
//  linhomes
//
//  Created by Leon on 7/19/17.
//  Copyright © 2017 linhtek. All rights reserved.
//

import Foundation

class Device {
    var id: String // mini mac address on devices
    var name: String // custom name
    var ssid: String // access phone ssid
    var password: String // access phone password -> wpa2
    var ip: String // dhcp ip alloc
    var style: Int64 // now, 1 -> switches
    var status: Int64 // for one pin status of style 1
    
    init(id: String) {
        self.id = id // because we have many id, determine with self
        name = ""
        ssid = ""
        password = ""
        ip = ""
        style = 0
        status = 0
    }
    
    init(id: String, name: String, ssid: String, password: String, ip: String, style: Int64, status: Int64) {
        self.id = id
        self.name = name
        self.ssid = ssid
        self.password = password
        self.ip = ip
        self.style = style
        self.status = status
    }
    
    func display(){
        print("Display device ->")
        print("id: "+self.id)
        print("name: "+self.name)
        print("ssid: "+self.ssid)
        print("password: "+self.password)
        print("ip: "+self.ip)
        print("style: \(self.style)")
        print("status: \(self.status)")
        print("Display device <- ")
    }
}
