//
//  ViewController.swift
//  microblog
//
//  Created by Alexey Il on 26.09.2021.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // save auth status user
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user != nil{
                print("user is signed in")
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                
                let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                
                self.present(homeViewController, animated: true, completion: nil)
            }
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }


}

