//
//  ListTableViewController.swift
//  linhomes
//
//  Created by Leon on 7/20/17.
//  Copyright © 2017 linhtek. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    //MARK: Properties
    
    var devices = [Device]()
    let iplug = UIImage(named: "plug24")
    let idirect = UIImage(named: "right24")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load devices list from db
        devices = LinhomesDB.instance.getDevices()
        
        // custom navifation bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.167707, green: 0.157497, blue: 0.167455, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ListTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListTableViewCell else {
            fatalError("The dequeued cell is not an instance of ListTableViewCell.")
        }
        
        // Fetches the appropriate device for the data source layout.
        let device = devices[indexPath.row]
        
        cell.labelName.text = device.name
//        cell.labelName.sizeToFit()
        cell.iconImage.image = iplug
        cell.iconDirect.image = idirect

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = devices[indexPath.row]
        print("Item \(device.name) selected")
    }

    // MARK: - Navigation
    
    @IBAction func home(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scan(_ sender: UIBarButtonItem) {
        print("Navigation to Scan")
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ScanningContainerID") as! ScanViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.present(navController, animated:true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }

}
