//
//  SignUpViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 14/05/2021.
//

import UIKit
import FirebaseAuth
class SignUpViewController: UIViewController {
    
    @IBOutlet var textFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        if let userEmail = textFields.first?.text, let userPassword = textFields.last?.text {
            
            Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "toWelcome", sender: self)
                }
                
            }
        }
        
    }
    
}


