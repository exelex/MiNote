//
//  HandleViewController.swift
//  microblog
//
//  Created by Alexey Il on 28.09.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HandleViewController: UIViewController {
    
    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var handleField: UITextField!
    @IBOutlet weak var startBtn: UIBarButtonItem!
    @IBOutlet weak var errorMessage: UILabel!
    
    var userUid: String?
    var rootRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.userUid = Auth.auth().currentUser!.uid
    }
    
    
    
    @IBAction func startBtnTapped(_ sender: UIBarButtonItem) {
        self.rootRef.child("handles").child(self.handleField.text!).observeSingleEvent(of: .value, with: {( snapshot: DataSnapshot ) in
            if(!snapshot.exists()) {
                self.rootRef.child("user_profiles").child(self.userUid!).child("handle").setValue(self.handleField.text!.lowercased())
                
                self.rootRef.child("user_profiles").child(self.userUid!).child("name").setValue(self.fullnameField.text!)
                
                self.rootRef.child("handles").child(self.handleField.text!.lowercased()).setValue(self.userUid!)
                
                self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
            } else {
                self.errorMessage.text = "Уже используется"
            }
        })
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
