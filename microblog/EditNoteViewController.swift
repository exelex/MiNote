//
//  EditNoteViewController.swift
//  microblog
//
//  Created by Alexey Il on 22.12.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class EditNoteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var editNoteTitleField: UITextField!
    @IBOutlet weak var editNoteTextView: UITextView!

    var delegateHome: EditNoteViewControllerDelegate?

    func editNoteCallback() {
        delegateHome?.updateNoteList()
    }
    
    var databaseRef = Database.database().reference()
    var loggedInUser: AnyObject?
    var userUid: String?
    
    var paramKey: String?
    var paramTitle: String?
    var paramText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userUid = Auth.auth().currentUser!.uid
        self.loggedInUser = Auth.auth().currentUser
        editNoteTextView.textContainerInset = UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        editNoteTextView.text = "Add note text"
    }
    
    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem) {
        let noteLength = editNoteTextView.text.count
        let noteTitleLength = editNoteTitleField.text?.count
        
        if (noteLength > 0 && noteTitleLength != nil) {
            if let key = self.paramKey {
                let childUpdates = ["/notes/\(self.userUid!)/\(key)/text":self.editNoteTextView.text!,
                                    "/notes/\(self.userUid!)/\(key)/title":self.editNoteTitleField.text!,
                                    "/notes/\(self.userUid!)/\(key)/timestamp":"\(NSDate().timeIntervalSince1970)"] as [String : Any]
                self.databaseRef.updateChildValues(childUpdates)
                editNoteCallback()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

protocol EditNoteViewControllerDelegate {
    func updateNoteList()
}
