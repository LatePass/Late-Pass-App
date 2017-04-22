//
//  HomePage.swift
//  LatePass
//
//  Created by alden lamp on 4/22/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomePage: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var background: UIImageView!
    
    @IBOutlet var fromTextField: UITextField!
    @IBOutlet var toTextField: UITextField!
    @IBOutlet var reason: UITextField!
    
    
    
    @IBOutlet var requestButton: UIButton!
    @IBOutlet var historyButton: UIButton!
    
    
    var textOne = true
    
    
    let testArr = data["teachers"]! as! [String]
    
    
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.layer.zPosition = -1
        
        nameLabel.text = data["name"]! as! String
        
        fromTextField.inputView?.tintColor = UIColor.clear
        
        fromTextField.backgroundColor = UIColor.clear
        fromTextField.layer.borderColor = UIColor.white.cgColor
        fromTextField.layer.borderWidth = 2
        fromTextField.layer.cornerRadius = 16
        fromTextField.layer.masksToBounds = true
        fromTextField.textColor = UIColor.white
        fromTextField.attributedPlaceholder = NSAttributedString(string: "Teacher's Name", attributes : [NSForegroundColorAttributeName : UIColor.white])

        toTextField.backgroundColor = UIColor.clear
        toTextField.layer.borderWidth = 2
        toTextField.layer.borderColor = UIColor.white.cgColor
        toTextField.layer.cornerRadius = 16
        toTextField.layer.masksToBounds = true
        toTextField.textColor = UIColor.white
        toTextField.attributedPlaceholder = NSAttributedString(string: "Teacher's Name", attributes : [NSForegroundColorAttributeName : UIColor.white])
        
        reason.backgroundColor = UIColor.clear
        reason.layer.borderWidth = 2
        reason.layer.borderColor = UIColor.white.cgColor
        reason.layer.cornerRadius = 16
        reason.layer.masksToBounds = true
        reason.textColor = UIColor.white
        reason.attributedPlaceholder = NSAttributedString(string: "Reasoning", attributes : [NSForegroundColorAttributeName : UIColor.white])
        
        
        requestButton.layer.borderColor = UIColor.white.cgColor
        requestButton.layer.borderWidth = 2
        requestButton.layer.cornerRadius = 16
        requestButton.layer.masksToBounds = true
        
        historyButton.layer.borderColor = UIColor.white.cgColor
        historyButton.layer.borderWidth = 2
        historyButton.layer.cornerRadius = 16
        historyButton.layer.masksToBounds = true
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.clear
        pickerView.tintColor = UIColor.white
        
        fromTextField.delegate = self
        toTextField.delegate = self
        
//        print(pickerView.backgroundColor)
        
        fromTextField.inputView = pickerView
        toTextField.inputView = pickerView
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == toTextField{
            self.textOne = false
            toTextField.text = testArr[pickerView.selectedRow(inComponent: 0)]
        }else if textField == fromTextField{
            self.textOne = true
            fromTextField.text = testArr[pickerView.selectedRow(inComponent: 0)]
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return testArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(textOne)
        if (textOne){
            fromTextField.text = testArr[row]
        }else{
            toTextField.text = testArr[row]
        }
        
    }
 
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = testArr[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Avenir-Medium", size: 27.0)!,NSForegroundColorAttributeName:UIColor.black])
        return myTitle
    }
    
    @IBAction func request(_ sender: Any) {
        if fromTextField.text != "" && reason.text != "" && toTextField.text != ""{
            let ref = FIRDatabase.database().reference()
            
            let date = Date()
            let calendar = Calendar.current
            
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            var year = String(calendar.component(.year, from: date))
            year.remove(at: year.startIndex)
            year.remove(at: year.startIndex)
            
            let fullDate = "\(month)/\(day)/\(year)"
            
            var hour = calendar.component(.hour, from: date)
            var minutes = calendar.component(.minute, from: date)
            var timeS = "PM"
            if hour < 12{
                timeS = "AM"
            }else{
                hour -= 12
            }
            let fullTime = "\(hour):\(minutes) \(timeS)"
            
            var str = fullData["teacherToEmail"]![fromTextField.text!.replacingOccurrences(of: ".", with: "__PERIOD__")] as! String
            
            var count2 = ""
            
            if let count : Int = ((fullData["users"]![str.replacingOccurrences(of: ".", with: "__PERIOD__")]! as! [String : Any])["incoming"] as? [[String : Any]])?.count{
                count2 = "\(count)"
            }else{
                count2 = "0"
            }
            
            let data2 : [String : Any] = ["date" : fullDate, "from" : fromTextField.text!, "reason" : reason.text!, "student" : currentEmail, "time" : fullTime, "to" : toTextField.text!]
            
            
            
            
            ref.child("users").child(str.replacingOccurrences(of: ".", with: "__PERIOD__")).child("incoming").child("\(count2)").setValue(data2)
            
            toTextField.text = ""
            reason.text = ""
            fromTextField.text = ""
        }
    }
    
    @IBAction func history(_ sender: Any) {
        performSegue(withIdentifier: "showHistory", sender: nil)
    }
    
    
}
