//
//  HelperFunction.swift
//  Instagram Clone
//
//  Created by Nouf Aldoaij on 25/09/2019.
//  Copyright © 2019 Nouf Aldoaij. All rights reserved.
//

import Foundation
import UIKit

func showAlertMessages(title:String?,message:String?,view:UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
    alert.addAction(cancelAction)
    view.present(alert, animated: true, completion: nil)
}


func validateUserEmailAddress(_ email:String) -> Bool {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: email)
}

func validateUserEmailAndpassword(view:UIViewController, email:String, password:String) -> Bool {
    if !validateUserEmailAddress(email) {
        showAlertMessages(title: nil, message: "Email Address is not correct formatted", view: view)
        return false
    } else if password.count < 6 {
        showAlertMessages(title: nil, message: "The password must be 6 characters long or more", view: view)
        return false
    }
    return true
}
