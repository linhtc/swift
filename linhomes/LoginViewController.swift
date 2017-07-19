//
//  LoginViewController.swift
//  linhomes
//
//  Created by Leon on 7/18/17.
//  Copyright © 2017 linhtek. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var uiTextPhone: UITextField!
    @IBOutlet weak var uiTextPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Delete user -> will be removed after
//        LinhomesDB.instance.deleteUser(cphone: "0961095661")
        
        // Sync all users from Firebase
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // get data from firebase
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            //            let value = snapshot.value as? NSDictionary
            //            let username = value?["username"] as? String ?? ""
            //            let user = User.init(username: username)
//            print(value as Any)
//            print(snapshot.childrenCount) // I got the expected number of items
            print("users -> \(snapshot.childrenCount)")
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
//                print(rest.value as Any)
                let item = rest.childSnapshot(forPath: "info").value as? NSDictionary
                let name = item?["name"] as? String ?? ""
                let phone = item?["phone"] as? String ?? ""
                let password = item?["pw"] as? String ?? ""
                let user = User.init(phone: phone, name: name, password: password, status: 0, sync: 0)
                user.display()
                if !LinhomesDB.instance.checkUserExisted(cphone: phone){
                    let result = LinhomesDB.instance.addUser(newUser: user)
                    print("Insert \(phone) to db -> \(result)")
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        // remove all observers
//        ref.removeAllObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    @IBAction func login(_ sender: UIButton) {
        // initital loading
        let alert = UIAlertController(title: nil, message: "Đang xác thực...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        // check logged after 3s
        perform(#selector(checkUserLogged), with: nil, afterDelay: 3)
        
        // perform login
        let phone = uiTextPhone.text ?? ""
        let password = uiTextPassword.text ?? ""
        if !phone.isEmpty && !password.isEmpty{
            let user = LinhomesDB.instance.getUser(cphone: phone)
            if !user.phone.isEmpty && !user.password.isEmpty{
                if user.password.caseInsensitiveCompare(password) == .orderedSame{
                    user.status = 1
                    let result = LinhomesDB.instance.updateUser(cphone: phone, newUser: user)
                    print("Update user \(user.phone) -> \(result)")
                }
            }
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        print("Navigation to Register")
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "RegisterContainerID") as! RegisterViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.present(navController, animated:true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
    }
    
    func checkUserLogged() {
        dismiss(animated: false, completion: nil)
        if LinhomesDB.instance.checkUserLogged(){
            print("Login success")
            dismiss(animated: true, completion: nil)
        } else{
            print("Login fail")
        }
    }
    
}
