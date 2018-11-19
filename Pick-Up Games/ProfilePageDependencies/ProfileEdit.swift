//
//  ProfileEdit.swift
//  Pick-Up Games
//
//  Created by David Otwell on 11/12/18.
//  Copyright © 2018 Amir Babaei. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class ProfileEdit: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var Bio: UITextField!
    @IBOutlet weak var Interests: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func DoneEditing(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        let REF_PROF = Database.database().reference().child("users").child(userID!)
        
        if (self.Username.text != "Edit Username") {
            REF_PROF.child("username").setValue(self.Username.text!)
        }
        if (self.Name.text != "Edit Name") {
            REF_PROF.child("Full Name").setValue(self.Name.text!)
        }
        if (self.Age.text != "Edit Age") {
            REF_PROF.child("Age").setValue(self.Age.text!)
        }
        if (self.Bio.text != "Edit Bio") {
            REF_PROF.child("Bio").setValue(self.Bio.text!)
        }
        if (self.Interests.text != "Edit Interests") {
            REF_PROF.child("Interests").setValue(self.Interests.text!)
        }
    }
}