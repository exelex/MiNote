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

        Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user != nil{
                
                print("user is signed in")
                
                //open homeViewController
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                
                let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                
                //send the user to the homescreen
                self.present(homeViewController, animated: true, completion: nil)
                
            }
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }


}

