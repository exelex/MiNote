//
//  LoginViewController.swift
//  microblog
//
//  Created by Alexey Il on 27.10.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIBarButtonItem!
    @IBOutlet weak var errorMessage: UILabel!
    
    
    var rootRef = Database.database().reference()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtnTapped(_ sender: UIBarButtonItem) {
        Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
            if (error == nil) {
                self.rootRef.child("user_profiles").child((user?.user.uid)!).child("handle").observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                    
                    if(!snapshot.exists()) {
                        self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                    } else {
                        self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                    }
                })
            } else {
                self.errorMessage.text = error?.localizedDescription
            }
        }
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
