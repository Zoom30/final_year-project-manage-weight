//
//  ViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 18/01/2021.
//

import UIKit
import RealmSwift
import Firebase
class StartStageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var initialWeightTextField: UITextField!
    @IBOutlet weak var initialHeightTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var accessToInitalHeightAndWeight : Results<InitialWeightAndHeight>?
    var accessToTargetWeight : Results<SetTargetWeight>?
    var accessToWeightHistoryData : Results<WeightHistoryData>?
    
    
    let db = Firestore.firestore()
    
    //MARK: - viewDidLoad() method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialWeightTextField.delegate = self
        initialHeightTextField.delegate = self
        loadData()
        
        
        if accessToInitalHeightAndWeight!.isEmpty {
            print("no initial values")
        }else{
            self.performSegue(withIdentifier: "goToSetTargetWeight", sender: self)
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        resizeViewOnKeyboardAppearDisappear()
        hideKeyboardWhenTappedAround()
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //imposes restrictions on the type of strings that can be inserted into the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters1 = CharacterSet.decimalDigits
        let allowedCharacters2 = CharacterSet.punctuationCharacters
        let characterSet = CharacterSet(charactersIn: string)
        if allowedCharacters1.isSuperset(of: characterSet) || textField.text!.filter({$0 == "."}).count < 1{
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
        if (((initialWeightTextField.text != "") && (initialWeightTextField.text!.filter({$0 == "."}).count < 2)) && ((initialHeightTextField.text != "") && (initialHeightTextField.text!.filter({$0 == "."}).count < 2))) && (!initialWeightTextField.text!.contains("-") && !initialHeightTextField.text!.contains("-")) {
            continueButton.isEnabled = true
        }
        else {
            continueButton.isEnabled = false
        }
        
    }
    
    
    //saves input data from the textfield and performs segue to the next screen (set target weight)
    @IBAction func continuePressed(_ sender: UIButton) {
        
        let newWeightAndHeight = InitialWeightAndHeight()
        newWeightAndHeight.weight = Double(initialWeightTextField.text!)!
        newWeightAndHeight.height = Double(initialHeightTextField.text!)!
        
        let updateWeightHistoryEntry = WeightHistoryData()
        updateWeightHistoryEntry.weightEntry = Double(initialWeightTextField.text!)!
        if let realm = try? Realm(){
            try! realm.write{
                realm.add(newWeightAndHeight)
                realm.add(updateWeightHistoryEntry)
            }
        }
        
//        var ref: DocumentReference? = nil
//        ref = db.collection("initial param").addDocument(data: [
//            "Height" : initialHeightTextField.text!,
//            "Weight" : initialWeightTextField.text!
//        ])
//        { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
             self.performSegue(withIdentifier: "goToSetTargetWeight", sender: self)
//            }
//        }
    }
    
    
    //loads already saved data from the realm file
    func loadData() -> Void {
        if let realm = try? Realm(){
            accessToInitalHeightAndWeight = realm.objects(InitialWeightAndHeight.self)
            accessToTargetWeight = realm.objects(SetTargetWeight.self)
            accessToWeightHistoryData = realm.objects(WeightHistoryData.self)
        }
    }
    
    
    
}

