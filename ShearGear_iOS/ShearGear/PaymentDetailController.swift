//
//  PaymentDetailController.swift
//  ShearGear
//
//  Created by Kevin on 5/25/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
import SendGrid
import IDMPhotoBrowser
import NTMonthYearPicker

class PaymentDetailController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var homeCellPhone: UITextField!
    @IBOutlet weak var workPhone: UITextField!
    @IBOutlet weak var placeOfWork: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var shipStreetAddress: UITextField!
    @IBOutlet weak var shipAddressLine2: UITextField!
    @IBOutlet weak var shipCity: UITextField!
    @IBOutlet weak var shipState: UITextField!
    @IBOutlet weak var shipZipCode: UITextField!
    @IBOutlet weak var shipCountry: UITextField!
    
    @IBOutlet weak var businessResidentalSegment: UISegmentedControl!
    
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var billStreetAddress: UITextField!
    @IBOutlet weak var billAddressLine2: UITextField!
    @IBOutlet weak var billCity: UITextField!
    @IBOutlet weak var billState: UITextField!
    @IBOutlet weak var billZipCode: UITextField!
    @IBOutlet weak var billCountry: UITextField!
    
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var expirationDate: UITextField!
    @IBOutlet weak var cvvCode: UITextField!
    
    @IBOutlet weak var cardHolderFirstName: UITextField!
    @IBOutlet weak var cardHolderLastName: UITextField!
    
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var cardType = ["Visa", "Mastercard", "Amex", "Discover"]
    
    var countries = NSLocale.isoCountryCodes.map { (code:String) -> String in
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
    }

    var objectID:String? = nil
    var productObject:PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delaysContentTouches = false
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 4
        
        comments.layer.cornerRadius = 4
        comments.layer.borderColor = UIColor.gray.cgColor
        comments.layer.borderWidth = 1
        
        //let datePicker = UIDatePicker()
        //datePicker.datePickerMode = .date
        //datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        //expirationDate.inputView = datePicker
        
        let monthPicker = NTMonthYearPicker()
        monthPicker.datePickerMode = NTMonthYearPickerModeMonthAndYear
        expirationDate.inputView = monthPicker
        monthPicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        
        let countryPicker = UIPickerView()
        countryPicker.tag = 1001
        countryPicker.delegate = self
        countryPicker.dataSource = self
        shipCountry.inputView = countryPicker
        
        let billCountryPicker = UIPickerView()
        billCountryPicker.tag = 1002
        billCountryPicker.delegate = self
        billCountryPicker.dataSource = self
        billCountry.inputView = billCountryPicker
/*
        let cardPicker = UIPickerView()
        cardPicker.tag = 1003
        cardPicker.delegate = self
        cardPicker.dataSource = self
        cardNumber.inputView = cardPicker
*/
        
        let usIndex = countries.index(of: "United States")
        if usIndex != nil {
            countries.remove(at: usIndex!)
        }
        countries.insert("United States", at: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if LoginController.emailAddress == "" {
            return
        }
        
        let query = PFQuery(className: "PaymentInfo")
        query.whereKey("email", equalTo: LoginController.emailAddress)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        query.findObjectsInBackground(block: {
            objects, error in
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: false)
                
                if objects != nil && objects!.count != 0 {
                    let object = objects![0]
                    self.firstName.text = object["firstName"] as? String
                    self.lastName.text = object["lastName"] as? String
                    self.homeCellPhone.text = object["homeCellPhone"] as? String
                    self.workPhone.text = object["workPhone"] as? String
                    self.placeOfWork.text = object["placeOfWork"] as? String
                    self.email.text = object["email"] as? String
                    self.shipStreetAddress.text = object["shipStreetAddress"] as? String
                    self.shipAddressLine2.text = object["shipAddressLine2"] as? String
                    self.shipCity.text = object["shipCity"] as? String
                    self.shipState.text = object["shipState"] as? String
                    self.shipZipCode.text = object["shipZipCode"] as? String
                    self.shipCountry.text = object["shipCountry"] as? String
                    let isBusiness = object["IsBusiness"] as? Bool
                    if isBusiness == true {
                        self.businessResidentalSegment.selectedSegmentIndex = 0
                    }
                    self.businessName.text = object["businessName"] as? String
                    self.billStreetAddress.text = object["billStreetAddress"] as? String
                    self.billAddressLine2.text = object["billAddressLine2"] as? String
                    self.billCity.text = object["billCity"] as? String
                    self.billState.text = object["billState"] as? String
                    self.billZipCode.text = object["billZipCode"] as? String
                    self.billCountry.text = object["billCountry"] as? String
                    self.cardNumber.text = object["cardNumber"] as? String
                    self.expirationDate.text = object["expirationDate"] as? String
                    self.cvvCode.text = object["cvvCode"] as? String
                    self.cardHolderFirstName.text = object["cardHolderFirstName"] as? String
                    self.cardHolderLastName.text = object["cardHolderLastName"] as? String
                    self.comments.text = object["comments"] as? String
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Submission Error", message: message + " field is required. Please enter a value.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    func showAlertWith(fullMsg:String) {
        let alert = UIAlertController(title: "Submission Error", message: fullMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: false, completion: nil)
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        if firstName.text == "" || lastName.text == "" {
            showAlert(message: "Contact Name")
            return
        }
        
        if homeCellPhone.text == "" {
            showAlert(message: "Home or Cell Phone")
            return
        }
        
        if homeCellPhone.text?.characters.count != 10 {
            showAlertWith(fullMsg: "Please enter a valid phone number.")
            return
        }
        
        if (workPhone.text! != "" && workPhone.text?.characters.count != 10) {
            showAlertWith(fullMsg: "Please enter a valid phone number.")
            return
        }
        
        if email.text == "" {
            showAlert(message: "Email Address")
            return
        }
        
        if email.text?.contains("@") == false {
            showAlertWith(fullMsg: "Please enter a valid email address.")
            return
        }
        
        if shipStreetAddress.text == "" || shipCity.text == "" || shipState.text == "" || shipState.text == "" || shipZipCode.text == "" {
            showAlert(message: "Shipping Address")
            return
        }
        
        if cardNumber.text == "" {
            showAlert(message: "Credit or Debit Card Number")
            return
        }
        
        if expirationDate.text == "" {
            showAlert(message: "Expiration Date")
            return
        }
        
        if cvvCode.text == "" {
            showAlert(message: "CVV Code")
            return
        }
        
        if (cvvCode.text?.characters.count)! < 3 {
            showAlertWith(fullMsg: "Please enter a valid CVV code.")
            return
        }
        
        if cardHolderFirstName.text == "" || cardHolderLastName.text == "" {
            showAlert(message: "Cardholder Name")
            return
        }
        
        if LoginController.emailAddress == "" {
            showPasswordPrompt()
            return
        }
        
        let query = PFQuery(className: "PaymentInfo")
        query.whereKey("email", equalTo: LoginController.emailAddress)
        query.whereKey("password", equalTo: LoginController.passwordStr)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        query.findObjectsInBackground(block: {
            objects, error in
            
            DispatchQueue.main.async {
                if objects != nil && objects!.count != 0 {
                    let payment = objects![0]
                    payment["firstName"] = self.firstName.text
                    payment["lastName"] = self.lastName.text
                    payment["homeCellPhone"] = self.homeCellPhone.text
                    payment["workPhone"] = self.workPhone.text
                    payment["placeOfWork"] = self.placeOfWork.text
                    payment["email"] = self.email.text
                    payment["shipStreetAddress"] = self.shipStreetAddress.text
                    payment["shipAddressLine2"] = self.shipAddressLine2.text
                    payment["shipCity"] = self.shipCity.text
                    payment["shipState"] = self.shipState.text
                    payment["shipZipCode"] = self.shipZipCode.text
                    payment["shipCountry"] = self.shipCountry.text
                    if self.businessResidentalSegment.selectedSegmentIndex == 0 {
                        payment["IsBusiness"] = true
                    }
                    else {
                        payment["IsBusiness"] = false
                    }
                    
                    payment["businessName"] = self.businessName.text
                    payment["billStreetAddress"] = self.billStreetAddress.text
                    payment["billAddressLine2"] = self.billAddressLine2.text
                    payment["billCity"] = self.billCity.text
                    payment["billState"] = self.billState.text
                    payment["billZipCode"] = self.billZipCode.text
                    payment["billCountry"] = self.billCountry.text
                    payment["cardNumber"] = self.cardNumber.text
                    payment["expirationDate"] = self.expirationDate.text
                    payment["cvvCode"] = self.cvvCode.text
                    payment["cardHolderFirstName"] = self.cardHolderFirstName.text
                    payment["cardHolderLastName"] = self.cardHolderLastName.text
                    payment["comments"] = self.comments.text
                    
                    self.productObject["email"] = self.email.text
                    self.productObject.saveInBackground()
                    
                    payment.saveInBackground(block: {
                        bSuccess, error in
                        
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            if error == nil {
                                let personalization = Personalization(recipients: "maurice@freebirdshears.com")
                                let htmlText = Content(contentType: ContentType.htmlText, value: "<p>Contract Name: \(self.firstName.text!) \(self.lastName.text!)</p><br><p>Home or Cell Phone: \(self.homeCellPhone.text!)</p><br><p>Work Phone: \(self.workPhone.text!)</p><br><p>Place of Work: \(self.placeOfWork.text!)</p><br><p>Email: \(self.email.text!)</p><br><h2>Shipping Address</h2><br><p>\(self.shipStreetAddress.text!)</p><br><p>\(self.shipAddressLine2.text!)</p><br><p>\(self.shipCity.text!)</p><br><p>\(self.shipState.text!)</p><br><p>\(self.shipZipCode.text!)</p><br><p>\(self.shipCountry.text!)</p><br><p>Business Name: \(self.businessName.text!)</p><br><h2>Billing Address</h2><br><p>\(self.billStreetAddress.text!)</p><br><p>\(self.billAddressLine2.text!)</p><br><p>\(self.billCity.text!)</p><br><p>\(self.billState.text!)</p><br><p>\(self.billZipCode.text!)</p><br><p>\(self.billCountry.text!)</p><br><p>Credit or Debit Card Number: \(self.cardNumber.text!)</p><br><p>Expiration Date: \(self.expirationDate.text!)</p><br><p>CVV Code: \(self.cvvCode.text!)</p><br><p>Cardholder Name: \(self.cardHolderFirstName.text!) \(self.cardHolderLastName.text!)</p><br><p>Comments and Special instructions:</p><br><p>\(self.comments.text!)</p><br><p>Please check payment information https://parse-dashboard.back4app.com/apps/2de0f9ed-b5c5-4780-8cac-845599f3617b/browser/PaymentInfo</p>")
                                
                                let email = Email(
                                    personalizations: [personalization],
                                    from: Address("maurice@freebirdshears.com"),
                                    content: [htmlText],
                                    subject: "Payment Information Added"
                                )
                                do {
                                    try Session.shared.send(request: email)
                                } catch {
                                    print(error)
                                }
                                
                                self.performSegue(withIdentifier: "success", sender: nil)
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
                else {
                    self.showPasswordPrompt()
                }
            }
        })
    }
    
    func updateInfo(password:String) {
        let payment = PFObject(className: "PaymentInfo")
        payment["firstName"] = firstName.text
        payment["lastName"] = lastName.text
        payment["homeCellPhone"] = homeCellPhone.text
        payment["workPhone"] = workPhone.text
        payment["placeOfWork"] = placeOfWork.text
        payment["email"] = email.text
        payment["shipStreetAddress"] = shipStreetAddress.text
        payment["shipAddressLine2"] = shipAddressLine2.text
        payment["shipCity"] = shipCity.text
        payment["shipState"] = shipState.text
        payment["shipZipCode"] = shipZipCode.text
        payment["shipCountry"] = shipCountry.text
        if businessResidentalSegment.selectedSegmentIndex == 0 {
            payment["IsBusiness"] = true
        }
        else {
            payment["IsBusiness"] = false
        }
        
        payment["businessName"] = businessName.text
        payment["billStreetAddress"] = billStreetAddress.text
        payment["billAddressLine2"] = billAddressLine2.text
        payment["billCity"] = billCity.text
        payment["billState"] = billState.text
        payment["billZipCode"] = billZipCode.text
        payment["billCountry"] = billCountry.text
        payment["cardNumber"] = cardNumber.text
        payment["expirationDate"] = expirationDate.text
        payment["cvvCode"] = cvvCode.text
        payment["cardHolderFirstName"] = cardHolderFirstName.text
        payment["cardHolderLastName"] = cardHolderLastName.text
        payment["comments"] = comments.text
        payment["password"] = password
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.productObject["email"] = self.email.text
        self.productObject.saveInBackground()
        
        payment.saveInBackground(block: {
            bSuccess, error in
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == nil {
                    let personalization = Personalization(recipients: "maurice@freebirdshears.com")
                    let htmlText = Content(contentType: ContentType.htmlText, value: "<p>Contract Name: \(self.firstName.text!) \(self.lastName.text!)</p><br><p>Home or Cell Phone: \(self.homeCellPhone.text!)</p><br><p>Work Phone: \(self.workPhone.text!)</p><br><p>Place of Work: \(self.placeOfWork.text!)</p><br><p>Email: \(self.email.text!)</p><br><h2>Shipping Address</h2><br><p>\(self.shipStreetAddress.text!)</p><br><p>\(self.shipAddressLine2.text!)</p><br><p>\(self.shipCity.text!)</p><br><p>\(self.shipState.text!)</p><br><p>\(self.shipZipCode.text!)</p><br><p>\(self.shipCountry.text!)</p><br><p>Business Name: \(self.businessName.text!)</p><br><h2>Billing Address</h2><br><p>\(self.billStreetAddress.text!)</p><br><p>\(self.billAddressLine2.text!)</p><br><p>\(self.billCity.text!)</p><br><p>\(self.billState.text!)</p><br><p>\(self.billZipCode.text!)</p><br><p>\(self.billCountry.text!)</p><br><p>Credit or Debit Card Number: \(self.cardNumber.text!)</p><br><p>Expiration Date: \(self.expirationDate.text!)</p><br><p>CVV Code: \(self.cvvCode.text!)</p><br><p>Cardholder Name: \(self.cardHolderFirstName.text!) \(self.cardHolderLastName.text!)</p><br><p>Comments and Special instructions:</p><br><p>\(self.comments.text!)</p><br><p>Please check payment information https://parse-dashboard.back4app.com/apps/2de0f9ed-b5c5-4780-8cac-845599f3617b/browser/PaymentInfo</p>")
                    
                    let email = Email(
                        personalizations: [personalization],
                        from: Address("maurice@freebirdshears.com"),
                        content: [htmlText],
                        subject: "Payment Information Added"
                    )
                    do {
                        try Session.shared.send(request: email)
                    } catch {
                        print(error)
                    }
                    
                    self.performSegue(withIdentifier: "success", sender: nil)
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
    
    var inputField:UITextField? = nil
    func showPasswordPrompt() {
        let alertController = UIAlertController(title: "Create Password", message: "Please create password for your account.", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {
            textfield in
            textfield.text = ""
            textfield.isSecureTextEntry = true
            textfield.placeholder = "Password"
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            action in
            DispatchQueue.main.async {
                let textfield = alertController.textFields![0]
                if textfield.text == "" {
                    self.showAlertWith(fullMsg: "Password is empty.")
                }
                else {
                    self.updateInfo(password: textfield.text!)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            DispatchQueue.main.async {
                self.showAlertWith(fullMsg: "You should create password for your account.")
            }
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: false, completion: nil)
    }
    
    func dateChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        
        expirationDate.text = dateFormatter.string(from: sender.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
/*
        if pickerView.tag == 1003 {
            return cardType[row]
        }
*/
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
/*
        if pickerView.tag == 1003 {
            return cardType.count
        }
*/
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1001 {
            shipCountry.text = countries[row]
        }
        else if pickerView.tag == 1002 {
            billCountry.text = countries[row]
        }
/*
        else {
            cardNumber.text = cardType[row]
        }
*/
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == shipCountry || textField == billCountry) && textField.text == "" {
            textField.text = countries[0]
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        
        if textField == homeCellPhone || textField == workPhone {
            return newLength <= 10
        }
        
        if textField == cvvCode {
            return newLength <= 4
        }
        
        return true
    }
    
    @IBAction func onClickCVVCodeLearnMore(_ sender: Any) {
        let photo = IDMPhoto(image: #imageLiteral(resourceName: "cvv_image"))
        let browser = IDMPhotoBrowser(photos: [photo!])
        browser?.displayToolbar = false
        self.present(browser!, animated: true, completion: nil)
    }
    
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
