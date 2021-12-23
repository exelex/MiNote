//
//  NewNoteViewController.swift
//  microblog
//
//  Created by Alexey Il on 15.12.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewNoteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var newNoteTitleField: UITextField!
    @IBOutlet weak var newNoteTextView: UITextView!
    
    var databaseRef = Database.database().reference()
    var loggedInUser: AnyObject?
    var userUid: String?
    
    var delegateHome: NewNoteViewControllerDelegate?

    func newNoteCallback() {
        print(delegateHome)
        delegateHome?.updateNoteList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userUid = Auth.auth().currentUser!.uid
        self.loggedInUser = Auth.auth().currentUser
        newNoteTextView.textContainerInset = UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        newNoteTextView.text = "Add note text"
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(newNoteTextView.textColor == UIColor.lightGray)
        {
            newNoteTextView.text = ""
            newNoteTextView.textColor = UIColor.black
        }
    }
    
    
    @IBAction func saveNoteBtnTapped(_ sender: UIBarButtonItem) {
        let noteLength = newNoteTextView.text.count
        let noteTitleLength = newNoteTitleField.text?.count
        
        if (noteLength > 0 && noteTitleLength != nil) {
            if let key = self.databaseRef.child("notes").childByAutoId().key {
                let childUpdates = ["/notes/\(self.userUid!)/\(key)/text":self.newNoteTextView.text!,
                                    "/notes/\(self.userUid!)/\(key)/title":self.newNoteTitleField.text!,
                                    "/notes/\(self.userUid!)/\(key)/timestamp":"\(NSDate().timeIntervalSince1970)"] as [String : Any]
                self.databaseRef.updateChildValues(childUpdates)
                newNoteCallback()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}


protocol NewNoteViewControllerDelegate {
    func updateNoteList()
}
