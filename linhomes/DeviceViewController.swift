//
//  DeviceViewController.swift
//  linhomes
//
//  Created by Leon on 7/23/17.
//  Copyright © 2017 linhtek. All rights reserved.
//

import UIKit
import Starscream

class DeviceViewController: UIViewController {
    
    //MARK: Properties
    
    var id = ""
    var device:Device? = nil
    var socket:WebSocket? = nil
    @IBOutlet weak var uiButtonControl: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get device id from list table view
        var staStr = "Tắt"
        print("Device id is \(id)")
        self.device = LinhomesDB.instance.getDevice(cid: self.id)
        self.device?.display()
        if self.device?.status == 1{
            staStr = "Bật"
            
        }
        
        // set device name to nav title
        uiButtonControl.setTitle(staStr, for: .normal)
        
        // custom navifation bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.167707, green: 0.157497, blue: 0.167455, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationItem.title = self.device?.name
        
        // custom corner for button control and tap evt
        let tapEvt = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        tapEvt.minimumPressDuration = 0.0
        
        uiButtonControl.layer.cornerRadius = uiButtonControl.bounds.size.height / 2
        uiButtonControl.layer.borderWidth = 3.0
        uiButtonControl.layer.borderColor = UIColor.white.cgColor
        uiButtonControl.clipsToBounds = true
        uiButtonControl.contentMode = .scaleToFill
        uiButtonControl.addGestureRecognizer(tapEvt)
        
        // connect to ws
        wsHandshake()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Control
    
    func handleLongTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .began{
            print("began")
            sender.view?.backgroundColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        }
        if sender.state == .ended{
            print("ended")
            sender.view?.backgroundColor = UIColor(red: 0.167707, green: 0.157497, blue: 0.167455, alpha: 1.0)
            var staStr = uiButtonControl.titleLabel?.text ?? ""
            if staStr.caseInsensitiveCompare("Bật") == .orderedSame{
                staStr = "Tắt"
            } else{
                staStr = "Bật"
            }
            uiButtonControl.setTitle(staStr, for: .normal)
            print(staStr)
        }
    }
    
    
    // MARK: - Navigation

    // Connect to web socket
    func wsHandshake(){
        var url = "ws://192.168.4.1:8889";
        if !(self.device?.ip.isEmpty)!{
            url = "ws://"+(self.device?.ip)!+":8889";
        }
        print("ws handshaking \(url)...")
        socket = WebSocket(url: URL(string: url)!)
        //websocketDidConnect
        socket?.onConnect = {
            print("websocket is connected")
        }
        //websocketDidDisconnect
        socket?.onDisconnect = { (error: NSError?) in
            print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
        }
        //websocketDidReceiveMessage
        socket?.onText = { (text: String) in
            print("got some text: \(text)")
        }
        //websocketDidReceiveData
        socket?.onData = { (data: Data) in
            print("got some data: \(data.count)")
        }
        //you could do onPong as well.
        socket?.connect()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }

}
