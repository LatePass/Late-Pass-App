//
//  ViewController.swift
//  LatePass
//
//  Created by alden lamp on 4/22/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

var data = [String : Any]()
var fullData = [String : [String : Any]]()

var currentEmail = "test@test.test"
var trans = false

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.color = UIColor.black
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        activityIndicator.isHidden = true
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
        imageView.layer.borderColor = UIColor(red: 0.102, green: 0.298, blue: 0.200, alpha: 1.00).cgColor
        imageView.layer.borderWidth = 2
        
        userName.backgroundColor = UIColor.clear
        userName.layer.borderColor = UIColor.white.cgColor
        userName.layer.borderWidth = 2
        userName.layer.cornerRadius = 16
        userName.layer.masksToBounds = true
        
        userName.textColor = UIColor.white
        userName.tintColor = UIColor.white
        userName.delegate = self
        
        userName.attributedPlaceholder = NSAttributedString(string: "Username", attributes:[NSForegroundColorAttributeName: UIColor.white])
        
        password.backgroundColor = UIColor.clear
        password.layer.borderColor = UIColor.white.cgColor
        password.layer.borderWidth = 2
        password.layer.masksToBounds = true
        password.layer.cornerRadius = 16
        password.delegate = self
        
        password.textColor = UIColor.white
        password.tintColor = UIColor.white
        
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes : [NSForegroundColorAttributeName : UIColor.white])
        
        logInButton.layer.borderWidth = 2
        logInButton.layer.borderColor = UIColor.white.cgColor
        logInButton.layer.cornerRadius = 16
        logInButton.layer.masksToBounds = true
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        view.endEditing(true)
        logIn("")
        return true
    }
    
    @IBAction func logIn(_ sender: Any) {
        activityIndicator.isHidden = false
        if userName.text != "" && password.text != ""{
            FIRAuth.auth()?.signIn(withEmail: userName.text!, password: password.text!, completion: {
                user, error in
                
                self.activityIndicator.isHidden = true
                
                if error != nil{
                    self.alert(text: error!.localizedDescription, title: "Log In Failed")
                }else{
                    let ref = FIRDatabase.database().reference()
                    ref.observe(.value, with: {
                        snapshot in
                        
                        
                        self.activityIndicator.isHidden = true
                        
                        fullData = snapshot.value! as! [String : [String : Any]]
                        let users = ((snapshot.value! as! [String : [String : Any]])["users"] as! [String : [String : Any]])[self.userName.text!.replacingOccurrences(of: ".", with: "__PERIOD__")]!
                        data = users
                        currentEmail = self.userName.text!
                        if !trans{
                            self.performSegue(withIdentifier: "showHome", sender: nil)
                            trans = true
                        }
                    })
                    
                }
            })
        }else{
            activityIndicator.isHidden = true
            alert(text: "Please enter a email and password", title: "Log In Failed")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        activityIndicator.isHidden = false
        
        if userName.text != "" && password.text != ""{
            
            FIRAuth.auth()?.createUser(withEmail: userName.text!, password: password.text!, completion: {
                user, error in
                
                if error != nil{
                    self.activityIndicator.isHidden = true
                    self.alert(text: error!.localizedDescription, title: "Sign Up Failed")
                }else{
                    self.logIn("")
                }
            })
        }else{
            activityIndicator.isHidden = true
            alert(text: "Please enter an email and password", title: "Sign Up Failed")
        }
    }
}

extension UIViewController{
    func alert(text : String, title: String){
        var alert = UIAlertView()
        alert.alertViewStyle = UIAlertViewStyle.default
        alert.title = title
        alert.message = text
        alert.addButton(withTitle: "Continue")
        alert.show()
    }
}

