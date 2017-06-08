//
//  SignupController.swift
//  ShearGear
//
//  Created by Jason on 6/7/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD


class SignupController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickCreate(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    func showAlertWith(fullMsg:String) {
        let alert = UIAlertController(title: "Crate Account Error", message: fullMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
