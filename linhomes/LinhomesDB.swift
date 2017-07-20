//
//  LinhomesDB.swift
//  linhomes
//
//  Created by Leon on 7/17/17.
//  Copyright © 2017 linhtek. All rights reserved.
//

import SQLite

class LinhomesDB {
    
    static let instance = LinhomesDB()
    private let db: Connection?
    private let users = Table("users")
    private let devices = Table("devices")
    private let ip = Expression<String>("ip")
    private let phone = Expression<String>("phone")
    private let name = Expression<String?>("name")
    private let password = Expression<String>("address")
    private let id = Expression<String>("id")
    private let ssid = Expression<String>("ssid")
    private let status = Expression<Int64>("status")
    private let sync = Expression<Int64>("sync")
    private let style = Expression<Int64>("style")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/Linhomes.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
        createTable()
    }
    
    func createTable() {
        do {
            try db!.run(users.create(ifNotExists: true) { table in
                table.column(phone, primaryKey: true)
                table.column(name)
                //                table.column(phone, unique: true)
                table.column(password)
                table.column(status)
                table.column(sync)
            })
        } catch {
            print("Unable to create table users")
        }
        do {
            try db!.run(devices.create(ifNotExists: true){ table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(ssid)
                table.column(password)
                table.column(ip)
                table.column(style)
                table.column(status)
            })
        } catch {
            print("Unable to create table devices")
        }
    }
    
    func addDevice(cid: String, cname: String, cssid: String, cpassword: String) -> Int64? {
        do {
            let insert = devices.insert(self.id <- cid, name <- cname, ssid <- cssid, password <- cpassword, ip <- "", style <- 1, status <- 0)
            let id = try db!.run(insert)
            // Add print(insert.asSQL()) to see the executed query itself
            return id
        } catch {
            print("Insert failed -> devices")
            return -1
        }
    }
    
    func addDevice(newDevice: Device) -> Bool {
        do {
            let insert = devices.insert(self.id <- newDevice.id, name <- newDevice.name, ssid <- newDevice.ssid, password <- newDevice.password, ip <- newDevice.ip, style <- newDevice.style, status <- newDevice.status)
            let id = try db!.run(insert)
            // Add print(insert.asSQL()) to see the executed query itself
            return id > 0 ? true : false
        } catch {
            print("Insert failed -> devices")
            return false
        }
    }
    
    func getDevices() -> [Device] {
        var devices = [Device]()
        do {
            for device in try db!.prepare(self.devices) {
                devices.append(Device(
                    id: device[id],
                    name: device[name]!,
                    ssid: device[ssid],
                    password: device[password],
                    ip: device[ip],
                    style: device[style],
                    status: device[status]
                    )
                )
            }
        } catch {
            print("Select failed -> devices")
        }
        
        return devices
    }
    
    func getDevice(cid: String) -> Device {
        var devices = [Device]()
        do {
            for device in try db!.prepare(self.devices.filter(id == cid)) {
                devices.append(Device(
                    id: device[id],
                    name: device[name]!,
                    ssid: device[ssid],
                    password: device[password],
                    ip: device[ip],
                    style: device[style],
                    status: device[status]
                    )
                )
            }
        } catch {
            print("getDevice failed")
        }
        if devices.count > 0{
            return devices.first!
        }
        return Device(id: "");
    }
    
    func checkDeviceExisted(cid: String) -> Bool {
        var devices = [Device]()
        do {
            for device in try db!.prepare(self.devices.filter(id == cid)) {
                devices.append(Device(id: device[id]))
            }
        } catch {
            print("checkDeviceExisted failed")
        }
        return devices.count > 0 ? true : false
    }
    
    func deleteDevice(cid: String) -> Bool {
        do {
            let device = devices.filter(id == cid)
            try db!.run(device.delete())
            return true
        } catch {
            print("Delete failed -> device")
        }
        return false
    }
    
    func updateDevice(cid:String, newDevice: Device) -> Bool {
        let device = devices.filter(id == cid)
        do {
            let update = device.update([
                id <- newDevice.id,
                name <- newDevice.name,
                ssid <- newDevice.ssid,
                password <- newDevice.password,
                ip <- newDevice.ip,
                style <- newDevice.style,
                status <- newDevice.status
            ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    // ###########3333
    
    func addUser(cphone: String, cname: String, cpassword: String) -> Int64? {
        do {
            let insert = users.insert(phone <- cphone, name <- cname, password <- cpassword, status <- 0, sync <- 0)
            let id = try db!.run(insert)
            // Add print(insert.asSQL()) to see the executed query itself
            return id
        } catch {
            print("Insert failed -> users")
            return -1
        }
    }
    
    func addUser(newUser: User) -> Bool {
        do {
            let insert = users.insert(phone <- newUser.phone, name <- newUser.name, password <- newUser.password, status <- newUser.status, sync <- newUser.sync)
            let id = try db!.run(insert)
            // Add print(insert.asSQL()) to see the executed query itself
            return id > 0 ? true : false
        } catch {
            print("Insert failed -> users")
            return false
        }
    }
    
    func getUsers() -> [User] {
        var users = [User]()
        
        do {
            for user in try db!.prepare(self.users) {
                users.append(User(
                    phone: user[phone],
                    name: user[name]!,
                    password: user[password],
                    status: user[status],
                    sync: user[sync]
                    )
                )
            }
        } catch {
            print("Select failed")
        }
        
        return users
    }
    
    func getUser(cphone: String) -> User {
        var users = [User]()
        do {
            for user in try db!.prepare(self.users.filter(phone == cphone)) {
                users.append(User(
                        phone: user[phone],
                        name: user[name]!,
                        password: user[password],
                        status: user[status],
                        sync: user[sync]
                    )
                )
            }
        } catch {
            print("getUser failed")
        }
        if users.count > 0{
            return users.first!
        }
        return User(phone: "");
    }
    
    func getUserLogged() -> User {
        var users = [User]()
        do {
            for user in try db!.prepare(self.users.filter(status == 1)) {
                users.append(User(
                    phone: user[phone],
                    name: user[name]!,
                    password: user[password],
                    status: user[status],
                    sync: user[sync]
                    )
                )
            }
        } catch {
            print("getUserLogged failed")
        }
        if users.count > 0{
            return users.first!
        }
        return User(phone: "");
    }
    
    func checkUserExisted(cphone: String) -> Bool {
        var users = [User]()
        do {
            for user in try db!.prepare(self.users.filter(phone == cphone)) {
                users.append(User(phone: user[phone]))
            }
        } catch {
            print("checkUserExisted failed")
        }
        return users.count > 0 ? true : false
    }
    
    func checkUserLogged() -> Bool {
        var users = [User]()
        do {
            for user in try db!.prepare(self.users.filter(status == 1)) {
                users.append(User(
                        phone: user[phone],
                        name: user[name]!,
                        password: user[password],
                        status: user[status],
                        sync: user[sync]
                    )
                )
            }
        } catch {
            print("checkUserLogged failed")
        }
        return users.count > 0 ? true : false
    }
    
    func deleteUser(cphone: String) -> Bool {
        do {
            let user = users.filter(phone == cphone)
            try db!.run(user.delete())
            return true
        } catch {
            print("Delete failed")
        }
        return false
    }
    
    func updateUser(cphone:String, newUser: User) -> Bool {
        let user = users.filter(phone == cphone)
        do {
            let update = user.update([
                name <- newUser.name,
                password <- newUser.password,
                status <- newUser.status,
                sync <- newUser.sync
            ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
}
