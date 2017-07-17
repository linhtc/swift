//
//  HomeViewController.swift
//  linhomes
//
//  Created by Leon on 7/12/17.
//  Copyright © 2017 linhtek. All rights reserved.
//

import UIKit
import os.log

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: 1.0, height: stackView.frame.size.height)
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.167707, green: 0.157497, blue: 0.167455, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.167707, green: 0.157497, blue: 0.167455, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
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
            let listViewContainer = ListViewController()
            self.navigationController?.pushViewController(listViewContainer, animated: true)
//            self.navigationController?.present(listViewContainer, animated: true, completion: nil)
//            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ListContainerID") as! ListViewController
//            let navController = UINavigationController(rootViewController: VC1)
//            self.present(navController, animated:true, completion: nil)
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
    
}
