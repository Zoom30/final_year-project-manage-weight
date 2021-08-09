//
//  RequiredCalorieCalculatorViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 26/01/2021.
//

import UIKit

class RequiredCalorieCalculatorViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var ageTextFeld: UITextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var activitySegmentControl: UISegmentedControl!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    
    let activityLevels = ["BMR", "Little", "Light", "Moderate", "Intense","Very Intense"]
    
    let calorieCalculator = CalculateCalorie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageTextFeld.delegate = self
        heightTextField.delegate = self
        weightTextField.delegate = self
        resizeViewOnKeyboardAppearDisappear()
        hideKeyboardWhenTappedAround()
        var counter = 0
        for _ in counter...activitySegmentControl.numberOfSegments-1{
            activitySegmentControl.setTitle(activityLevels[counter], forSegmentAt: counter)
            counter += 1
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
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toCalorieResults", sender: self)
    }
    
    
    @IBAction func activateCalculateButton(_ sender: UITextField) {
        if ((ageTextFeld.text != "") && (ageTextFeld.text!.filter({$0 == "."}).count < 2) && (ageTextFeld.text!.filter({$0 == " "}).count == 0))
            &&
            ((weightTextField.text != "") && (weightTextField.text!.filter({$0 == "."}).count < 2) && (weightTextField.text!.filter({$0 == " "}).count == 0) )
            &&
            ((heightTextField.text != "") && (heightTextField.text!.filter({$0 == "."}).count < 2) && (heightTextField.text!.filter({$0 == " "}).count == 0) )
        {
            calculateButton.isEnabled = true
        }else{
            calculateButton.isEnabled = false
        }
    }
    
    
    func currentBMR() -> Double {
        return calorieCalculator.calculate(age: Int(ageTextFeld.text!)!, gender: Int(genderSegmentControl.selectedSegmentIndex), height: Double(heightTextField.text!)!, weight: Double(weightTextField.text!)!, activityLevel: activitySegmentControl.selectedSegmentIndex)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCalorieResults" {
            let destinationVC = segue.destination as! CalorieResultsViewController
            destinationVC.maintainWeight = String(format: "%.2f", currentBMR())
            destinationVC.mildWeightLoss = String(format: "%.2f", currentBMR() * Double.random(in: 0.85...0.92))
            destinationVC.normalWeightLoss = String(format: "%.2f", currentBMR() * Double.random(in: 0.75...0.82))
            destinationVC.extremeWeightLoss = String(format: "%.2f", currentBMR() * Double.random(in: 0.55...0.62))
            
            destinationVC.mildWeightGain = String(format: "%.2f", currentBMR() * Double.random(in: 1.05...1.12))
            destinationVC.normalWeightGain = String(format: "%.2f", currentBMR() * Double.random(in: 1.20...1.28))
            destinationVC.fastWeightGain = String(format: "%.2f", currentBMR() * Double.random(in: 1.40...1.60))
        }
    }
    
    
}
