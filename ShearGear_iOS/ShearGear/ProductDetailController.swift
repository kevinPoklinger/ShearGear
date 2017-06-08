//
//  ProductDetailController.swift
//  ShearGear
//
//  Created by Kevin on 5/25/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
import SendGrid
import SHMultipleSelect
import IDMPhotoBrowser

class ProductDetailController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, SHMultipleSelectDelegate {

    @IBOutlet weak var subscription: UILabel!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var handField: UITextField!
    @IBOutlet weak var bladeType: UITextField!
    @IBOutlet weak var freeEngraving: UITextField!
    @IBOutlet weak var favoriteColor: UITextField!
    @IBOutlet weak var garmentSize: UITextField!
    @IBOutlet weak var handleType: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var likeEngraved: UITextField!
    @IBOutlet weak var lengthPreference: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var favoriteColors:[Int] = [Int]()
    var selectedLengths:[Int] = [Int]()
    var subscriptionText:String = ""
    var descriptionText:String = ""
    
    var hands = ["Right Handed", "Left Handed"]
    var bladeTypes = ["Mix of straight & curved", "curved only", "straight only"]
    var freeEngravings = ["Absolutely!", "No, Thank you"]
    var colors = ["Clear/White", "Black", "Pink", "Purple", "Dark Green", "Lime", "Red", "Blue", "Turquoise", "Yellow", "Orange"]
    var garmentSizes = ["small", "medium", "large", "XL", "XXL", "3X", "4X", "5X"]
    var preferredHandleTypes = ["Even (flippable)", "Offset (Ergo)", "Swivel ($5 surcharge per box)"]
    var deliveryFrequencies = ["Every month - Pay as you go", "Every month - Annual Plan paid monthly", "Every month - Annual Plan prepaid", "Every month - Annual Plan paid in2 installments of 300", "Every two month - Pay as you go ($29) renews every month until canceled", "Every two month - Annual Plan paid monthly", "Every two month - Annual Bi-Monthly Plan Prepaid", "Every Three month"]
    var lengths = ["All Sizes 7\"-9.5\"", "Medium 7-8.5\"", "Large: 8\"-10\""]
    
    var selectedPlan:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = 4
        continueButton.layer.masksToBounds = true
        scrollView.delaysContentTouches = false
        
        addHand()
        addBladeTypes()
        addFreeEngraving()
        addGarmentSizes()
        addPreferredHandleType()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if LoginController.emailAddress == "" {
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = PFQuery(className: "Product")
        query.whereKey("email", equalTo: LoginController.emailAddress)
        query.findObjectsInBackground(block: {
            objects, error in
            
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: false)
                
                if objects != nil && objects!.count != 0 {
                    let object = objects![0]
                    self.handField.text = object["Hand"] as? String
                    self.bladeType.text = object["BladeType"] as? String
                    self.freeEngraving.text = object["FreeEngraving"] as? String
                    self.garmentSize.text = object["GarmentSize"] as? String
                    self.handleType.text = object["PreferredHandleType"] as? String
                    self.lengthPreference.text = object["LengthPreference"] as? String
                    self.likeEngraved.text = object["LikeEngraved"] as? String
                    
                    let planStr = object["DeliveryFrequency"] as? String
                    if planStr != nil {
                        self.selectedPlan = planStr!
                    }
                    
                    var lengthStr = object["LengthPreference"] as? String
                    if lengthStr != nil {
                        lengthStr = lengthStr!.trimmingCharacters(in: .whitespaces)
                        var lengthArr:[String] = [String]()
                        lengthArr = lengthStr!.components(separatedBy: ",")
                        for lStr in lengthArr {
                            var index = 0
                            for orgL in self.lengths {
                                if lStr == orgL {
                                    self.selectedLengths.append(index)
                                    break
                                }
                            }
                            index += 1
                        }
                    }
                    
                    var colorStr = object["FavoriteColors"] as? String
                    self.favoriteColor.text = colorStr
                    if colorStr != nil {
                        colorStr = colorStr!.trimmingCharacters(in: .whitespaces)
                        var colorArr:[String] = [String]()
                        colorArr = colorStr!.components(separatedBy: ",")
                        for cStr in colorArr {
                            var index = 0
                            for orgC in self.colors {
                                if cStr == orgC {
                                    self.favoriteColors.append(index)
                                    break
                                }
                                index += 1
                            }
                        }
                    }
                }
            }
        })
        
    }
    
    func createPickerView() -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }
    
    func addHand() {
        let pickerView = createPickerView()
        pickerView.tag = 1001
        handField.inputView = pickerView
    }
    
    func addBladeTypes() {
        let pickerView = createPickerView()
        pickerView.tag = 1002
        bladeType.inputView = pickerView
    }
    
    func addFreeEngraving() {
        let pickerView = createPickerView()
        pickerView.tag = 1003
        freeEngraving.inputView = pickerView
    }
    
    func addGarmentSizes() {
        let pickerView = createPickerView()
        pickerView.tag = 1005
        garmentSize.inputView = pickerView
    }
    
    func addPreferredHandleType() {
        let pickerView = createPickerView()
        pickerView.tag = 1006
        handleType.inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let tag = pickerView.tag
        
        switch tag {
        case 1001:
            return hands.count
        case 1002:
            return bladeTypes.count
        case 1003:
            return freeEngravings.count
        case 1004:
            return colors.count
        case 1005:
            return garmentSizes.count
        case 1006:
            return preferredHandleTypes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tag = pickerView.tag
        
        switch tag {
        case 1001:
            handField.text = hands[row]
            break
        case 1002:
            bladeType.text = bladeTypes[row]
            break
        case 1003:
            freeEngraving.text = freeEngravings[row]
            break
        case 1004:
            favoriteColor.text = colors[row]
            break
        case 1005:
            garmentSize.text = garmentSizes[row]
            break
        case 1006:
            handleType.text = preferredHandleTypes[row]
            break
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let tag = pickerView.tag
        
        switch tag {
        case 1001:
            return hands[row]
        case 1002:
            return bladeTypes[row]
        case 1003:
            return freeEngravings[row]
        case 1004:
            return colors[row]
        case 1005:
            return garmentSizes[row]
        case 1006:
            return preferredHandleTypes[row]
        default:
            return nil
        }
    }
    
    @IBAction func onClickFavoriteColor(_ sender: Any) {
        let selectionView = SHMultipleSelect()
        selectionView.tag = 2001
        selectionView.delegate = self
        selectionView.rowsCount = colors.count
        selectionView.show()
    }
    
    @IBAction func onClickLengthPreference(_ sender: Any) {
        let selectionView = SHMultipleSelect()
        selectionView.tag = 2002
        selectionView.delegate = self
        selectionView.rowsCount = lengths.count
        selectionView.show()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text != "" || textField == likeEngraved || textField == favoriteColor {
            return
        }
        
        (textField.inputView as! UIPickerView).selectedRow(inComponent: 0)
        let tag = textField.inputView!.tag
        switch tag {
        case 1001:
            handField.text = hands[0]
            break
        case 1002:
            bladeType.text = bladeTypes[0]
            break
        case 1003:
            freeEngraving.text = freeEngravings[0]
            break
        case 1004:
            favoriteColor.text = colors[0]
            break
        case 1005:
            garmentSize.text = garmentSizes[0]
            break
        case 1006:
            handleType.text = preferredHandleTypes[0]
            break
        default:
            break
        }
    }
    
    @IBAction func onClickEngravingLearnMore(_ sender: Any) {
        let photo = IDMPhoto(image: #imageLiteral(resourceName: "freeengaging"))
        let browser = IDMPhotoBrowser(photos: [photo!])
        browser?.displayToolbar = false
        self.present(browser!, animated: true, completion: nil)
    }
    
    @IBAction func onClickHandleTypeLearnMore(_ sender: Any) {
        let photo = IDMPhoto(image: #imageLiteral(resourceName: "learn_more"))
        let browser = IDMPhotoBrowser(photos: [photo!])
        browser?.displayToolbar = false
        self.present(browser!, animated: true, completion: nil)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest:PlanController = segue.destination as! PlanController
        dest.hand = handField.text!
        dest.bladeType = bladeType.text!
        dest.freeEngraving = freeEngraving.text!
        dest.likeEngraved = likeEngraved.text!
        dest.favoriteColors = favoriteColor.text!
        dest.garmentSize = garmentSize.text!
        dest.preferedHandleType = handleType.text!
        dest.lengths = lengthPreference.text!
        dest.selectedPlanStr = selectedPlan
    }
    
    func multipleSelectView(_ multipleSelectView: SHMultipleSelect!, clickedBtnAt clickedBtnIndex: Int, withSelectedIndexPaths selectedIndexPaths: [Any]!) {
        if selectedIndexPaths == nil {
            return
        }
        
        if multipleSelectView.tag == 2001 {
            favoriteColors = [Int]()
            var colorStr = ""
            for indexPath in selectedIndexPaths {
                favoriteColors.append((indexPath as! IndexPath).row)
                colorStr += colors[(indexPath as! IndexPath).row] + ", "
            }
        
            if colorStr.contains(", ") == true {
                colorStr.remove(at: colorStr.index(before: colorStr.endIndex))
                colorStr.remove(at: colorStr.index(before: colorStr.endIndex))
            }
            favoriteColor.text = colorStr
        }
        else {
            selectedLengths = [Int]()
            var lengthStr = ""
            for indexPath in selectedIndexPaths {
                selectedLengths.append((indexPath as! IndexPath).row)
                lengthStr += lengths[(indexPath as! IndexPath).row] + ", "
            }
            if lengthStr.contains(", ") == true {
                lengthStr.remove(at: lengthStr.index(before: lengthStr.endIndex))
                lengthStr.remove(at: lengthStr.index(before: lengthStr.endIndex))
            }
            lengthPreference.text = lengthStr
        }
    }
    
    func multipleSelectView(_ multipleSelectView: SHMultipleSelect!, titleForRowAt indexPath: IndexPath!) -> String! {
        if multipleSelectView.tag == 2001 {
            return colors[indexPath.row]
        }
        else {
            return lengths[indexPath.row]
        }
    }
    
    func multipleSelectView(_ multipleSelectView: SHMultipleSelect!, setSelectedForRowAt indexPath: IndexPath!) -> Bool {
        if multipleSelectView.tag == 2001 {
            let index = favoriteColors.index(of: indexPath.row)
            if index == nil {
                return false
            }
            else {
                return true
            }
        }
        else {
            let index = selectedLengths.index(of: indexPath.row)
            if index == nil {
                return false
            }
            else {
                return true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
