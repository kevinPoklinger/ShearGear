//
//  SuccessController.swift
//  ShearGear
//
//  Created by Kevin on 5/25/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class SuccessController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var linkButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(goHomeScreen))
        gestureRec.delegate = self
        self.view.addGestureRecognizer(gestureRec)
    }
    
    func goHomeScreen(sender:UITapGestureRecognizer) {
        let pos = sender.location(in: self.view)
        if linkButton.frame.contains(pos) == false {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            delegate.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "homeController")
            delegate.window?.makeKeyAndVisible()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickLink(_ sender: Any) {
        let url = URL(string: "https://www.freebirdshears.com")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
