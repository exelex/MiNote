//
//  SignUpViewController.swift
//  microblog
//
//  Created by Alexey Il on 28.09.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpBtn: UIBarButtonItem!
    @IBOutlet weak var errorMessage: UILabel!
    
    var databaseRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpBtn.isEnabled = false
    }
    
    
    
    @IBAction func signUpBtnTapped(_ sender: UIBarButtonItem) {
        signUpBtn.isEnabled = false
        
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if (error != nil) {
                self.errorMessage.text = error?.localizedDescription
            } else {
                self.errorMessage.text = "Registered Succesfully"
        
                Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
                    
                    if (error == nil) {
                        self.databaseRef.child("user_profiles").child(user!.user.uid).child("email").setValue(self.emailField.text!)
                        
                        self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                    }
                    
                }
            }
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fieldChange(_ sender: Any) {
        let textEmail = emailField.text ?? ""
        let textPassword = passwordField.text ?? ""
        
        if(textEmail.count > 0 && textPassword.count > 0) {
            signUpBtn.isEnabled = true
        } else {
            signUpBtn.isEnabled = false
        }
    }
    
}
