//
//  RegisterViewController.swift
//  linhomes
//
//  Created by Leon on 7/18/17.
//  Copyright © 2017 linhtek. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var uiTextName: UITextField!
    @IBOutlet weak var uiTextPhone: UITextField!
    @IBOutlet weak var uiTextPassword: UITextField!
    @IBOutlet weak var uiTextRepassword: UITextField!
    var flagRegistered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // set false to flagRegistered
        self.flagRegistered = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // register new account
    @IBAction func register(_ sender: UIButton) {
        // validate
        let name = uiTextName.text ?? ""
        let phone = uiTextPhone.text ?? ""
        
        if !name.isEmpty && !phone.isEmpty{
            let password = uiTextPassword.text ?? ""
            let repassword = uiTextRepassword.text ?? ""
            if !password.isEmpty && password.caseInsensitiveCompare(repassword) == .orderedSame{
                // initital loading
                let alert = UIAlertController(title: nil, message: "Đang đăng ký...", preferredStyle: .alert)
                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                loadingIndicator.startAnimating();
                alert.view.addSubview(loadingIndicator)
                present(alert, animated: true, completion: nil)
                
                // check registered after 3s
                perform(#selector(checkUserRegistered), with: nil, afterDelay: 3)
                
                // Sync all users from Firebase
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                // get data from firebase
                ref.child("users").child(phone).child("info").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    print(snapshot.childrenCount) // I got the expected number of items
                    if snapshot.childrenCount > 0{ // if existed user account in firebase
                        self.flagRegistered = false
                    } else{ // perform register -> add information to firebase and store in sqlite
//                        ref.child("users").child(phone).childByAutoId().key
                        self.flagRegistered = true
                        let item = ["name": name, "phone": phone, "pw": password]
                        let childUpdates = ["/users/\(phone)/info": item]
                        ref.updateChildValues(childUpdates)
                        print("Add \(phone) to firebase")
                        
                        let user = User.init(phone: phone, name: name, password: password, status: 1, sync: 0)
                        let res = LinhomesDB.instance.addUser(newUser: user)
                        print("Add \(phone) to db -> \(res)")
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }

            } else{
                let alert = UIAlertController(title: "Cảnh báo", message: "Xác nhận mật khẩu chưa đúng", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else{
            let alert = UIAlertController(title: "Cảnh báo", message: "Hãy nhập đầy đủ thông tin", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // back to login, not perform login
    @IBAction func login(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
    }
    
    func checkUserRegistered() {
        dismiss(animated: false, completion: nil)
        if !self.flagRegistered{ // register failed
            let alert = UIAlertController(title: "Cảnh báo", message: "Tài khoản đã tồn tại hoặc có lỗi", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else{ // return login form/ open the main view
//            dismiss(animated: false, completion: nil)
            print("Navigation to Main view")
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "HomeContainerID") as! HomeViewController
            let navController = UINavigationController(rootViewController: VC1)
            self.present(navController, animated:true, completion: nil)
        }
    }

}
