//
//  SignUpViewController.swift
//  Instagram Clone
//
//  Created by Nouf Aldoaij on 24/09/2019.
//  Copyright © 2019 Nouf Aldoaij. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var avatarImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    // dismiss the keyboard when done button is cliked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        // Try to find next responder
        
        let nextResponder = textField.superview?.viewWithTag(nextTag)
        
        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder!.becomeFirstResponder()
            
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        EnabledSignButton()
    }
    
    func EnabledSignButton() {
        if validateSignInForm() {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = InstagramColors.darkBlueColor
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = InstagramColors.lightBlueColor
        }
    }
    
    func validateSignInForm () -> Bool {
        if emailTextField.text == nil || emailTextField.text == "" {
            return false
        } else if usernameTextField.text == nil || usernameTextField.text == "" {
            return false
        } else if fullNameTextField.text == nil || fullNameTextField.text == "" {
            return false
        } else if  passwordTextField.text == nil || passwordTextField.text == "" {
            return false
        }  else {
            return true
        }
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true , completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let avatarImage  = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        avatarImageButton.layer.cornerRadius = avatarImageButton.frame.width / 2
        avatarImageButton.layer.masksToBounds = true
        avatarImageButton.layer.borderColor = UIColor.black.cgColor
        avatarImageButton.layer.borderWidth = 2
        avatarImageButton.setImage(avatarImage, for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAvatarImage() -> Data {
        var avatarImage = UIImage(named: "profile_selected")
        if avatarImageButton.currentImage != UIImage(named: "plus_photo")  {
            avatarImage = avatarImageButton.currentImage!
        }
        return avatarImage!.jpegData(compressionQuality: 0.5)!
        
        
    }
    
    func createNewAccountWithEmailAndPassword () {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField!.text!) { (result, error) in
            if error == nil {
                self.AddUserAvatarToStorage(result: result)
            } else {
                showAlertMessages(title: nil, message: String(describing: error), view: self)
            }
        }
    }
    
    func AddUserAvatarToStorage(result: AuthDataResult?) {
        let image = self.getAvatarImage()
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("avatar_images").child(fileName)
        storageRef.putData(image, metadata: nil, completion: { (metadata, error) in
            
            // handle error
            if let error = error {
                showAlertMessages(title: nil, message: "Failed to upload image to Firebase Storage with error", view: self)
                print("Failed to upload image to Firebase Storage with error", error.localizedDescription)
                return
            }
            
            // UPDATE: - Firebase 5 must now retrieve download url
            storageRef.downloadURL(completion: { (downloadURL, error) in
                guard let profileImageUrl = downloadURL?.absoluteString else {
                    print("DEBUG: Profile image url is nil")
                    return
                }
                
                let dictionaryValues = ["name": self.fullNameTextField.text!,
                                        "username": self.usernameTextField.text!,
                                        "profileImageUrl": profileImageUrl]
                
                let values = [result?.user.uid: dictionaryValues]
                self.saveUserToDB(values: values)
            
            })
        })
    }
    
    func saveUserToDB(values: [String? : [String : String]]) {
        // save user info to database
        Database.database().reference().child("Users").updateChildValues(values, withCompletionBlock: { (error, databaseReference) in
            if error == nil {
                print("user create")
            } else {
                showAlertMessages(title: "Fail to create user", message: String(describing: error), view: self)
                print("fail to create user \(String(describing: error))")
                
            }
        })
    }
    
    @IBAction func addAvatarImage(_ sender: Any) {
        showImagePicker()
    }
    
    @IBAction func signInAction(_ sender: Any) {
        if validateSignInForm() && validateUserEmailAndpassword(view: self, email: emailTextField.text!, password: passwordTextField.text!) {
            createNewAccountWithEmailAndPassword()
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
