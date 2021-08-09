//
//  LoginPageViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 14/05/2021.
//

import UIKit
import FirebaseAuth
class LoginPageViewController: UIViewController {

    @IBOutlet var textFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()

        resizeViewOnKeyboardAppearDisappear()
        hideKeyboardWhenTappedAround()
        
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
//        if let userEmail = textFields.first?.text, let userPassword = textFields.last?.text {
//            Auth.auth().signIn(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in
//              guard let strongSelf = self else { return }
//              // ...
//                if let e = error {
//                    print(e)
//                } else {
//                    self?.performSegue(withIdentifier: "welcomeToFirstPage", sender: self)
//                }
//            }
//        }
        
        self.performSegue(withIdentifier: "welcomeToFirstPage", sender: self)
    }
    

}
