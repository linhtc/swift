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
    private let phone = Expression<String>("phone")
    private let name = Expression<String?>("name")
    private let password = Expression<String>("address")
    private let status = Expression<Int64>("status")
    private let sync = Expression<Int64>("sync")
    
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
            print("Unable to create table")
        }
    }
    
    func addUser(cphone: String, cname: String, cpassword: String) -> Int64? {
        do {
            let insert = users.insert(phone <- cphone, name <- cname, password <- cpassword, status <- 0, sync <- 0)
            let id = try db!.run(insert)
            // Add print(insert.asSQL()) to see the executed query itself
            return id
        } catch {
            print("Insert failed")
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
            print("Insert failed")
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
        return User(phone: "0");
    }
    
    func checkUserExisted(cphone: String) -> Bool {
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
