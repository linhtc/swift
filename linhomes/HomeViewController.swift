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
    @IBOutlet weak var uiScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        uiScroll.contentSize = CGSize(width: self.view.frame.size.width, height: 600)
//        uiScroll.setContentOffset(CGPoint(x: 0, y: max(uiScroll.contentSize.height - uiScroll.bounds.size.height, 0) ), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
