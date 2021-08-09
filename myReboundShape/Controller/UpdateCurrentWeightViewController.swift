//
//  UpdateCurrentWeightViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 10/02/2021.
//

import UIKit
import RealmSwift
class UpdateCurrentWeightViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var currentWeightTextField: UITextField!
    @IBOutlet weak var updateCurrentWeightButton: UIButton!
    
    var accessToInitialWeight : Results<InitialWeightAndHeight>?
    var accessToTargetWeight : Results<SetTargetWeight>?
    var accessToWeightHistoryData : Results<WeightHistoryData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentWeightTextField.delegate = self
        loadData()
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
    
    
    @IBAction func editingChanged(_ sender: UITextField) {
        if currentWeightTextField.text != "" && !currentWeightTextField.text!.contains("-") && currentWeightTextField.text!.filter({$0 == "."}).count < 2 && currentWeightTextField.text!.filter({$0 == " "}).count == 0{
            updateCurrentWeightButton.isEnabled = true
        }else{
            updateCurrentWeightButton.isEnabled = false
        }
    }
    
    
    
 
    func loadData(){
        if let realm  = try? Realm(){
            accessToTargetWeight = realm.objects(SetTargetWeight.self)
            accessToInitialWeight = realm.objects(InitialWeightAndHeight.self)
        }
    }
    
    @IBAction func updateCurrentWeightPressed(_ sender: UIButton) {
        
        let realm = try! Realm()
        let updatedWeight = realm.objects(InitialWeightAndHeight.self).first
        try! realm.write{
            updatedWeight?.weight = Double(currentWeightTextField.text!)!
        }
        
        
        let updateWeightHistoryEntry = WeightHistoryData()
        updateWeightHistoryEntry.weightEntry = Double(currentWeightTextField.text!)!
        if let realm = try? Realm(){
            try! realm.write{
                realm.add(updateWeightHistoryEntry)
            }
        }
        
        loadData()
        let updateInitialWeight = accessToInitialWeight![0].weight
        let targetWeight = accessToTargetWeight![0].targetWeight
        if updateInitialWeight < targetWeight {
            self.performSegue(withIdentifier: "toWGPFromUIW", sender: self)
        }else{
            self.performSegue(withIdentifier: "toWLPFromUIW", sender: self)
        }
        
        
    }
    
    
}
