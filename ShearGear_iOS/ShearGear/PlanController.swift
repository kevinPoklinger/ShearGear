//
//  PlanController.swift
//  ShearGear
//
//  Created by Kevin on 5/30/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
import SendGrid

class PlanController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var hand:String = ""
    var bladeType:String = ""
    var freeEngraving:String = ""
    var likeEngraved:String = ""
    var favoriteColors:String = ""
    var garmentSize:String = ""
    var preferedHandleType:String = ""
    var lengths:String = ""
    
    var plans:[String] = ["Month To Month $52.00", "Annual Plan - Prepaid $599.00 - Best Value!", "6 Month Plan - Prepaid $300.00 Fantastic Value!", "3 Month Plan - Prepaid $155.00 Great Value!", "Every Other Month $56.00 (That's only $28.00 a month)", "Annual Every Other Month Plan - Prepaid $336.00", "6 Month Every Other Month Plan - Prepaid $165.00"]
    var index = -1
    var selectedPlanStr:String = ""
    
    @IBOutlet weak var firstPlan: UILabel!
    @IBOutlet weak var secondPlan: UILabel!
    @IBOutlet weak var thirdPlan: UILabel!
    @IBOutlet weak var forthPlan: UILabel!
    @IBOutlet weak var fifthPlan: UILabel!
    @IBOutlet weak var sixthPlan: UILabel!
    @IBOutlet weak var seventhPlan: UILabel!
    
    @IBOutlet weak var selectedPlan: UILabel!
    
    var object:PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.layer.cornerRadius = 4
        continueButton.layer.masksToBounds = true
        scrollView.delaysContentTouches = false
        
        selectedPlan.text = selectedPlanStr
        // Do any additional setup after loading the view.
        var ind = 0
        for plan in plans {
            if plan == selectedPlanStr {
                self.index = ind
                break
            }
            ind += 1
        }

        if index == -1 {
            return
        }
        
        removeSelection()
        let attributeStr = NSMutableAttributedString(string: plans[index], attributes: [NSForegroundColorAttributeName: UIColor.green, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        switch index {
        case 0:
            firstPlan.attributedText = attributeStr
            break
        case 1:
            secondPlan.attributedText = attributeStr
            break
        case 2:
            thirdPlan.attributedText = attributeStr
            break
        case 3:
            forthPlan.attributedText = attributeStr
            break
        case 4:
            fifthPlan.attributedText = attributeStr
            break
        case 5:
            sixthPlan.attributedText = attributeStr
            break
        case 6:
            seventhPlan.attributedText = attributeStr
            break
        default:
            break
        }
        selectedPlan.text = "You selected the plan - \"\(plans[index])\""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeSelection() {
        if index == -1 {
            return
        }
        
        let attributeStr = NSMutableAttributedString(string: plans[index], attributes: [NSForegroundColorAttributeName: UIColor(red: 69 / 255.0, green: 141 / 255.0, blue: 1, alpha: 1.0), NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        switch index {
        case 0:
            firstPlan.attributedText = attributeStr
            break
        case 1:
            secondPlan.attributedText = attributeStr
            break
        case 2:
            thirdPlan.attributedText = attributeStr
            break
        case 3:
            forthPlan.attributedText = attributeStr
            break
        case 4:
            fifthPlan.attributedText = attributeStr
            break
        case 5:
            sixthPlan.attributedText = attributeStr
            break
        case 6:
            seventhPlan.attributedText = attributeStr
            break
        default:
            break
        }
    }
    
    @IBAction func onClickMonthToMonth(_ sender: Any) {
        removeSelection()
        index = 0
        let attributeStr = NSMutableAttributedString(string: plans[index], attributes: [NSForegroundColorAttributeName: UIColor.green, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        firstPlan.attributedText = attributeStr
        selectedPlan.text = "You selected the plan - \"\(plans[index])\""
    }

    @IBAction func onClickMonthAnnual(_ sender: Any) {
        removeSelection()
        index = 1
        let attributeStr = NSMutableAttributedString(string: plans[index], attributes: [NSForegroundColorAttributeName: UIColor.green, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        secondPlan.attributedText = attributeStr
        selectedPlan.text = "You selected the plan - \"\(plans[index])\""
    }
    
    @IBAction func onClickMonthAnnualPaid2(_ sender: Any) {
        removeSelection()
        index = 2
        let attributeStr = NSMutableAttributedString(string: plans[index], attributes: [NSForegroundColorAttributeName: UIColor.green, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        thirdPlan.attributedText = attributeStr
        selectedPlan.text = "You selected the plan - \"\(plans[index])\""
    }
    
    @IBAction func onClick3MonthTrial(_ sender: Any) {
        removeSelection()
        index = 3
        let attributeStr = NSMutableAttributedString(string: plans[index], attributes: [NSForegroundColorAttributeName: UIColor.green, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        forthPlan.attributedText = attributeStr
        selectedPlan.text = "You selected the plan - \"\(plans[index])\""
    }
    
    @IBAction func onClickTwoMonth(_ sender: Any) {
        removeSelection()
        index = 4
        let attributeStr = NSMutableAttributedString(string: plans[index], attributes: [NSForegroundColorAttributeName: UIColor.green, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        fifthPlan.attributedText = attributeStr
        selectedPlan.text = "You selected the plan - \"\(plans[index])\""
    }
    
    @IBAction func onClickTwoMonthAnnual(_ sender: Any) {
        removeSelection()
        index = 5
        let attributeStr = NSMutableAttributedString(string: plans[index], attributes: [NSForegroundColorAttributeName: UIColor.green, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        sixthPlan.attributedText = attributeStr
        selectedPlan.text = "You selected the plan - \"\(plans[index])\""
    }
    
    @IBAction func onClickSixMonthPlan(_ sender: Any) {
        removeSelection()
        index = 6
        let attributeStr = NSMutableAttributedString(string: plans[index], attributes: [NSForegroundColorAttributeName: UIColor.green, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        seventhPlan.attributedText = attributeStr
        selectedPlan.text = "You selected the plan - \"\(plans[index])\""
    }
    
    var objectID:String? = nil
    
    @IBAction func onClickContinue(_ sender: Any) {
        if index == -1 {
            let alert = UIAlertController(title: "Submission Error", message: "You should select a plan.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: false, completion: nil)
            return
        }
        
        if LoginController.emailAddress == "" {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let product = PFObject(className: "Product")
            objectID = product.objectId
            saveData(product: product)
            return
        }
        
        let query = PFQuery(className: "Product")
        MBProgressHUD.showAdded(to: self.view, animated: true)
        query.findObjectsInBackground(block: {
            objects, error in
            
            DispatchQueue.main.async {
                if objects != nil && objects!.count != 0 {
                    let product = objects![0]
                    self.saveData(product: product)
                }
                else {
                    LoginController.emailAddress = ""
                    LoginController.passwordStr = ""
                    let product = PFObject(className: "Product")
                    self.objectID = product.objectId
                    self.saveData(product: product)
                }
            }
        })
    }
    
    func saveData(product:PFObject) {
        self.object = product
        product["Hand"] = hand
        product["BladeType"] = bladeType
        product["LengthPreference"] = lengths
        product["FreeEngraving"] = freeEngraving
        product["LikeEngraved"] = likeEngraved
        product["FavoriteColors"] = favoriteColors
        product["GarmentSize"] = garmentSize
        product["PreferredHandleType"] = preferedHandleType
        product["DeliveryFrequency"] = plans[index]
        
        product.saveInBackground(block: {
            _, error in
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: false)
                if error == nil {
                    
                    let personalization = Personalization(recipients: "maurice@freebirdshears.com")
                    let htmlText = Content(contentType: ContentType.htmlText, value: "<p>Hand: \(self.hand)</p><br><p>Blade Types: \(self.bladeType)</p><br><p>Length Preferences: \(self.lengths)</p><br><p>FREE Engraving: \(self.freeEngraving)</p><br><p>What would you like engraved? \(self.likeEngraved)</p><br><p>Favorite Colors: \(self.favoriteColors)</p><br><p>Garment Size: \(self.garmentSize)</p><br><p>Preferred Handle Type: \(self.preferedHandleType)</p><br><p>Choose Plan/Delivery Frequency: \(self.plans[self.index])</p><br><p>Please check the product https://parse-dashboard.back4app.com/apps/2de0f9ed-b5c5-4780-8cac-845599f3617b/browser/Product</p>")
                    let email = Email(
                        personalizations: [personalization],
                        from: Address("maurice@freebirdshears.com"),
                        content: [htmlText],
                        subject: "Product Added"
                    )
                    do {
                        try Session.shared.send(request: email)
                    } catch {
                        print(error)
                    }
                    
                    self.performSegue(withIdentifier: "payment", sender: nil)
                }
                else {
                    let alert = UIAlertController(title: "Submission Error", message: "Unable to submit product detail, Please try again.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: false, completion: nil)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payment" {
            let dest:PaymentDetailController = segue.destination as! PaymentDetailController
            dest.objectID = objectID
            dest.productObject = self.object
        }
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
