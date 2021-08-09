//
//  InitialSetTargetWeightViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 21/01/2021.
//

import UIKit
import RealmSwift
class InitialSetTargetWeightViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var setTargetWeightWeightTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    
    var accessToSetTargetWeight : Results<SetTargetWeight>?
    var accessToInitialSetWeightAndHeight : Results<InitialWeightAndHeight>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTargetWeightWeightTextField.delegate = self
        resizeViewOnKeyboardAppearDisappear()
        hideKeyboardWhenTappedAround()
        loadWeightInfo()
        loadTargetWeightInfo()
        
        if accessToSetTargetWeight!.isEmpty{
            print("no target weight values")
        }else{
            let initialWeight = accessToInitialSetWeightAndHeight![0].weight
            let targetWeight = accessToSetTargetWeight![0].targetWeight
            if targetWeight > initialWeight {
                self.performSegue(withIdentifier: "goToWGPOptions", sender: self)
            }
            else {
                self.performSegue(withIdentifier: "goToWLPOptions", sender: self)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters1 = CharacterSet.decimalDigits
        let allowedCharacters2 = CharacterSet.punctuationCharacters
        let characterSet = CharacterSet(charactersIn: string)
        if allowedCharacters1.isSuperset(of: characterSet) {
            return true
        }
        else if allowedCharacters2.isSuperset(of: characterSet){
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        if (setTargetWeightWeightTextField.text != "" && !setTargetWeightWeightTextField.text!.contains("-")) && (setTargetWeightWeightTextField.text!.filter({$0 == "."}).count < 2){
            continueButton.isEnabled = true
        }
        else{
            continueButton.isEnabled = false
        }
    }
    
    
    
    func loadWeightInfo(){
        if let realm = try? Realm(){
            accessToInitialSetWeightAndHeight = realm.objects(InitialWeightAndHeight.self)
        }
    }
    func loadTargetWeightInfo(){
        if let realm = try? Realm(){
            accessToSetTargetWeight = realm.objects(SetTargetWeight.self)
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        
        loadWeightInfo()
        let newTargetWeight = SetTargetWeight()
        newTargetWeight.targetWeight = Double(setTargetWeightWeightTextField.text!)!
        
        if let realm = try? Realm(){
            try! realm.write{
                realm.add(newTargetWeight)
            }
        }
        
        loadTargetWeightInfo()
        
        let initialWeight = accessToInitialSetWeightAndHeight![0].weight
        let targetWeight = accessToSetTargetWeight![0].targetWeight
        if targetWeight > initialWeight {
            print("performing WLG segue")
            self.performSegue(withIdentifier: "goToWGPOptions", sender: self)
        }
        else{
            print("performing WLP segue")
            self.performSegue(withIdentifier: "goToWLPOptions", sender: self)
            
        }
        
    }
}
