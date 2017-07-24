//
//  HomeViewController.swift
//  linhomes
//
//  Created by Leon on 7/12/17.
//  Copyright © 2017 linhtek. All rights reserved.
//

import UIKit
import os.log
import Firebase

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var uiSecurity: UIView!
    @IBOutlet weak var uiWeather: UIView!
    @IBOutlet weak var uiMedia: UIView!
    @IBOutlet weak var uiControl: UIView!
    @IBOutlet weak var uiHealth: UIView!
    @IBOutlet weak var uiTree: UIView!
    @IBOutlet weak var uiSetting: UIView!
    @IBOutlet weak var uiMore: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        perform(#selector(checkUserLogged), with: nil, afterDelay: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: 1.0, height: stackView.frame.size.height)
        self.automaticallyAdjustsScrollViewInsets = false
        
        // custom navifation bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.167707, green: 0.157497, blue: 0.167455, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        // create event listenner for all services
        let tapSecurity = UITapGestureRecognizer(target: self, action: #selector(handleTapServices))
        let tapWeather = UITapGestureRecognizer(target: self, action: #selector(handleTapServices))
        let tapMedia = UITapGestureRecognizer(target: self, action: #selector(handleTapServices))
        let tapControl = UITapGestureRecognizer(target: self, action: #selector(handleTapServices))
        let tapHealth = UITapGestureRecognizer(target: self, action: #selector(handleTapServices))
        let tapTree = UITapGestureRecognizer(target: self, action: #selector(handleTapServices))
        let tapSetting = UITapGestureRecognizer(target: self, action: #selector(handleTapServices))
        let tapMore = UITapGestureRecognizer(target: self, action: #selector(handleTapServices))
        
        uiSecurity.addGestureRecognizer(tapSecurity)
        uiWeather.addGestureRecognizer(tapWeather)
        uiMedia.addGestureRecognizer(tapMedia)
        uiControl.addGestureRecognizer(tapControl)
        uiHealth.addGestureRecognizer(tapHealth)
        uiTree.addGestureRecognizer(tapTree)
        uiSetting.addGestureRecognizer(tapSetting)
        uiMore.addGestureRecognizer(tapMore)
    }
    
    func handleTapServices(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options:[UIViewAnimationOptions.curveLinear], animations: {
            sender.view?.backgroundColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
            sender.view?.backgroundColor = UIColor(red: 0.167707, green: 0.157497, blue: 0.167455, alpha: 1.0)
        }, completion: nil)
        
        if sender.view == uiSecurity{
            print("uiSecurity");
        } else if sender.view == uiWeather{
            print("uiWeather");
        } else if sender.view == uiMedia{
            print("uiMedia");
        } else if sender.view == uiControl{
            print("uiControl");
//            let listViewContainer = ListTableViewController()
//            self.navigationController?.pushViewController(listViewContainer, animated: true)
            
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ListTableContainerID") as! ListTableViewController
            let navController = UINavigationController(rootViewController: VC1)
            self.present(navController, animated:true, completion: nil)

        } else if sender.view == uiHealth{
            print("uiHealth");
        } else if sender.view == uiTree{
            print("uiTree");
        } else if sender.view == uiSetting{
            print("uiSetting");
        } else if sender.view == uiMore{
            print("uiMore");
        } else{
            print("Hi");
        }
    }
    
    func checkUserLogged() {
//        var res = LinhomesDB.instance.deleteUser(cphone: "0961095660")
//        print("Remove user -> \(res)")
//        res = LinhomesDB.instance.deleteUser(cphone: "0961095661")
//        print("Remove user -> \(res)")
        if LinhomesDB.instance.checkUserLogged(){
            print("Logged")
            
            let user = LinhomesDB.instance.getUserLogged()            
            if !user.phone.isEmpty{
                // Sync all users from Firebase
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                // get data from firebase
                ref.child("users/"+user.phone+"/devices").observeSingleEvent(of: .value, with: { (snapshot) in
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        let key = rest.key
                        let name = rest.childSnapshot(forPath: "cn").value as? String ?? ""
                        let ssid = rest.childSnapshot(forPath: "ws").value as? String ?? ""
                        let password = rest.childSnapshot(forPath: "wp").value as? String ?? ""
                        let ip = rest.childSnapshot(forPath: "wi").value as? String ?? ""
                        let style = rest.childSnapshot(forPath: "sty").value as? Int64 ?? 0
                        let status = rest.childSnapshot(forPath: "sta").value as? Int64 ?? -1
                        let device = Device.init(id: key, name: name, ssid: ssid, password: password, ip: ip, style: style, status: status)
                        device.display()
                        if !LinhomesDB.instance.checkDeviceExisted(cid: key){
                            let result = LinhomesDB.instance.addDevice(newDevice: device)
                            print("Insert device \(key) to db -> \(result)")
                        } else{
                            let result = LinhomesDB.instance.updateDevice(cid: key, newDevice: device)
                            print("Update device \(key) to db -> \(result)")
                        }
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        } else{
            print("Navigation to Login")
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "LoginContainerID") as! LoginViewController
            let navController = UINavigationController(rootViewController: VC1)
            self.present(navController, animated:true, completion: nil)
        }
    }
    
}
