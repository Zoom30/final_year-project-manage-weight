//
//  SetTargetWeight2ViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 25/01/2021.
//

import UIKit
import RealmSwift
class UpdateCurrentWeightTargetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var updateWeightTextField: UITextField!
    @IBOutlet weak var updateTargetWeightButton: UIButton!
    
    var accessToInitialWeightAndHeight : Results<InitialWeightAndHeight>?
    var accessToTargetWeight : Results<SetTargetWeight>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWeightTextField.delegate = self
        hideKeyboardWhenTappedAround()
        resizeViewOnKeyboardAppearDisappear()
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
    
    @IBAction func editingChaged(_ sender: UITextField) {
        if updateWeightTextField.text != "" && !updateWeightTextField.text!.contains("-") && updateWeightTextField.text!.filter({$0 == " "}).count == 0 && updateWeightTextField.text!.filter({$0 == "."}).count < 2{
            updateTargetWeightButton.isEnabled = true
        }else{
            updateTargetWeightButton.isEnabled = false
        }
    }
    
    
    @IBAction func updateTargetWeightPressed(_ sender: UIButton) {
        loadData()
        
        let realm = try! Realm()
        let updatedWeight = realm.objects(SetTargetWeight.self).first
        try! realm.write{
            updatedWeight?.targetWeight = Double(updateWeightTextField.text!)!
        }
        loadData()
        let initialWeight = accessToInitialWeightAndHeight![0].weight
        let updatedTargetWeight = accessToTargetWeight![0].targetWeight
        if initialWeight < updatedTargetWeight {
            self.performSegue(withIdentifier: "toWGPFromUCTW", sender: self)
        }else{
            self.performSegue(withIdentifier: "toWLPFromUCTW", sender: self)
        }
        
    }
    
    func loadData(){
        if let realm = try? Realm(){
            accessToInitialWeightAndHeight = realm.objects(InitialWeightAndHeight.self)
            accessToTargetWeight = realm.objects(SetTargetWeight.self)
        }
    }
    
}
