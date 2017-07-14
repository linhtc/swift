//
//  HomeViewController.swift
//  linhomes
//
//  Created by Leon on 7/12/17.
//  Copyright © 2017 linhtek. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: 1.0, height: stackView.frame.size.height)
        scrollView.delaysContentTouches = false
    }
    
    func handleTapServices(_ sender: UITapGestureRecognizer) {
        print("handleTapServices");
        UIView.animate(withDuration: 0.2, delay: 0.0, options:[UIViewAnimationOptions.curveLinear], animations: {
            sender.view?.backgroundColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
            sender.view?.backgroundColor = UIColor(red: 0.167707, green: 0.157497, blue: 0.167455, alpha: 1.0)
        }, completion: nil)
        
//        if sender.view == uiSecurity{
//            print("uiSecurity");
//        } else if sender.view == uiWeather{
//            print("uiWeather");
//        }
    }
    
}
