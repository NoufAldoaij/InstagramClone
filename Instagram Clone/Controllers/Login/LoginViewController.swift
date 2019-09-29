//
//  LoginViewController.swift
//  Instagram Clone
//
//  Created by Nouf Aldoaij on 18/09/2019.
//  Copyright © 2019 Nouf Aldoaij. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController,UITextFieldDelegate  {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        EnabledLoginButton()
    }
    
    func EnabledLoginButton() {
        if validateLogin() {
            loginButton.isEnabled = true
            loginButton.backgroundColor = InstagramColors.darkBlueColor
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = InstagramColors.lightBlueColor
        }
    }
    
    func validateLogin() -> Bool {
        if emailTextField.text == "" || emailTextField.text == nil {
            return false
        } else if passwordTextField.text == "" || passwordTextField.text == nil{
            return false
        } else {
            return true
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
//        if validateLogin() && validateUserEmailAndpassword(view: self, email: emailTextField.text!, password: passwordTextField.text!) {
//            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
//                if error == nil {
//                    print("User Press login button")
//                } else {
//                    showAlertMessages(title: "Unalbe to Login user", message: String(describing: error), view: self)
//                }
//            }
//        } else {
//            showAlertMessages(title: nil, message: "Please enter user email and password", view: self)
//        }
        DispatchQueue.main.async {
            self.view.endEditing(true)
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarViewController")
            self.present(controller, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func createNewAccount(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
