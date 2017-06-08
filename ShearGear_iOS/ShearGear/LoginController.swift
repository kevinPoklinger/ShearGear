//
//  LoginController.swift
//  ShearGear
//
//  Created by Jason on 6/7/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class LoginController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    static var emailAddress:String = ""
    static var passwordStr:String = ""
    var objectID:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickLogin(_ sender: Any) {
        if email.text == "" {
            showAlertWith(fullMsg: "Please type Email address.")
            return
        }
        
        if email.text?.contains("@") != true {
            showAlertWith(fullMsg: "Please type vaild Email address.")
            return
        }
        
        if password.text == "" {
            showAlertWith(fullMsg: "Please type password.")
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let query = PFQuery(className: "PaymentInfo")
        query.whereKey("email", equalTo: email.text!)
        query.findObjectsInBackground(block: {
            objects, error in
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if objects == nil || objects!.count == 0 {
                    self.showAlertWith(fullMsg: "There isn't any account associated this Email Address.")
                }
                else {
                    for object in objects! {
                        let passVal = object["password"] as! String
                        if passVal == self.password.text! {
                            LoginController.emailAddress = self.email.text!
                            LoginController.passwordStr = self.password.text!
                            self.objectID = object.objectId
                            self.performSegue(withIdentifier: "login", sender: nil)
                            return
                        }
                    }
                    self.showAlertWith(fullMsg: "Invalid Email Address or Password.")
                }
            }
        })
    }
    
    func showAlertWith(fullMsg:String) {
        let alert = UIAlertController(title: "Login Error", message: fullMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: false, completion: nil)
    }

    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
