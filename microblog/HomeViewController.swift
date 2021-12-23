//
//  HomeViewController.swift
//  microblog
//
//  Created by Alexey Il on 27.10.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditNoteViewControllerDelegate, NewNoteViewControllerDelegate {
    
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    @IBOutlet weak var homeTableView: UITableView!
    
    
    var databaseRef = Database.database().reference()
    var loggedInUser: AnyObject?
    var loggedInUserId: String?
    var loggedInUserData: AnyObject?
    var notes = [NSDictionary]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeTableView.backgroundColor = UIColor(red: 0.14, green: 0.14, blue: 0.14, alpha: 1.00)
        self.loggedInUser = Auth.auth().currentUser
        self.loggedInUserId = Auth.auth().currentUser!.uid
        
        updateNoteList()
        
//        self.databaseRef.child("user_profiles").child(self.loggedInUserId!).observeSingleEvent(of: .value, with: {( snapshot: DataSnapshot ) in
//
//            self.loggedInUserData = snapshot
//
//            self.databaseRef.child("notes/\(self.loggedInUserId!)").observe(.childAdded, with: {
//                (snapshot: DataSnapshot) in
//
//                let key = snapshot.key
//                let snapshot = snapshot.value as? NSDictionary
//                snapshot?.setValue(key, forKey: "key")
//
//                self.notes.append(snapshot!)
//
//                self.homeTableView.insertRows(at: [IndexPath(row:0,section:0)], with: UITableView.RowAnimation.automatic)
//                self.activityLoading.stopAnimating()
//            }) {(error) in
//                print(error.localizedDescription)
//            }
//        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell", for: indexPath) as! HomeViewTableViewCell
        let note = notes[(self.notes.count - 1) - (indexPath.row)]
        let noteText = note["text"] as! String
        let noteTitle = note["title"] as! String
        
        cell.configure(title: noteTitle, text: noteText)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let rowNum = self.notes[(self.notes.count - 1) - (indexPath.row)]
        
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            if let key = rowNum["key"] as? String {
                self.databaseRef.child("notes/\(self.loggedInUserId!)").child(key).removeValue(completionBlock: { (error, ref) in

                    if error != nil {
                        print("Failed to delete note:", error!)
                        return
                    }

                    self.notes.remove(at: (self.notes.count - 1) - (indexPath.row))
                    self.homeTableView.reloadData()
                })
            }
        }
        let actionEdit = UIContextualAction(style: .destructive, title: "Edit") {  (contextualAction, view, boolValue) in
            if let key = self.notes[(self.notes.count - 1) - (indexPath.row)]["key"] as? String {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                guard let editNoteViewController = storyboard.instantiateViewController(identifier: "EditNoteViewController") as? EditNoteViewController else { return }
//                editNoteViewController.paramKey = key
                
                let dest = storyboard.instantiateViewController(withIdentifier: "EditNoteViewController") as! EditNoteViewController
                
                dest.paramKey = key
                dest.paramTitle = rowNum["title"] as? String
                dest.paramText = rowNum["text"] as? String
                dest.delegateHome = self
                
                dest.modalPresentationStyle = .pageSheet
                dest.modalTransitionStyle = .coverVertical
                self.present(dest, animated: true, completion: nil)
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [actionDelete, actionEdit])
        actionDelete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        actionEdit.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

        return swipeActions
    }
    

    func updateNoteList() {
        self.notes = [NSDictionary]()
        self.homeTableView.reloadData()
        
        print("update")
        
        self.databaseRef.child("user_profiles").child(self.loggedInUserId!).observeSingleEvent(of: .value, with: {( snapshot: DataSnapshot ) in
            
            self.loggedInUserData = snapshot
            
            self.databaseRef.child("notes/\(self.loggedInUserId!)").observe(.childAdded, with: {
                (snapshot: DataSnapshot) in
                
                let key = snapshot.key
                let snapshot = snapshot.value as? NSDictionary
                snapshot?.setValue(key, forKey: "key")
                
                self.notes.append(snapshot!)
                
                self.homeTableView.insertRows(at: [IndexPath(row:0,section:0)], with: UITableView.RowAnimation.automatic)
                self.activityLoading.stopAnimating()
            }) {(error) in
                print(error.localizedDescription)
            }
        })
    }
    
    @IBAction func logoutBtnTapped(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let welcomeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        
        self.present(welcomeViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func addNoteBtnTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dest = storyboard.instantiateViewController(withIdentifier: "NewNoteViewController") as! NewNoteViewController
        
        dest.delegateHome = self
        
        dest.modalPresentationStyle = .pageSheet
        dest.modalTransitionStyle = .coverVertical
        self.present(dest, animated: true, completion: nil)
    }
    
}


