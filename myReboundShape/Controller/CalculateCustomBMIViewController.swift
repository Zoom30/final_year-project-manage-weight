//
//  CalculateCustomBMIViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 09/02/2021.
//

import UIKit

class CalculateCustomBMIViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var customWeightTextField: UITextField!
    @IBOutlet weak var customHeightTextField: UITextField!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    
    let nhsLink = "https://www.nhs.uk/conditions/obesity/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customWeightTextField.delegate = self
        customHeightTextField.delegate = self
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
    
    
    @IBAction func notEmptyCheck(_ sender: UITextField) {
        if (customWeightTextField.text != "" && !customWeightTextField.text!.contains("-")) && (customHeightTextField.text != "" && !customHeightTextField.text!.contains("-")) {
            calculateButton.isEnabled = true
        }else{
            calculateButton.isEnabled = false
        }
    }
    
    
    

    @IBAction func calculatePressed(_ sender: UIButton) {
        let customWeight = Double(customWeightTextField.text!)!
        let customHeight = Double(customHeightTextField.text!)!
        let bmi = customWeight / pow(customHeight, 2)
        bmiLabel.text = String(format: "%.2f", bmi)
        
        if bmi < 18.5 {
            commentLabel.text = BMIComments.underweight
            
        }else if bmi < 24.9 {
            commentLabel.text = BMIComments.normal
        }else if bmi < 29.9 {
            commentLabel.text = BMIComments.overweight
        }else if bmi < 39.9 {
            let adviseTap = UITapGestureRecognizer(target: self, action: #selector(openNHSLink(sender:)))
            commentLabel.isUserInteractionEnabled = true
            commentLabel.addGestureRecognizer(adviseTap)
            commentLabel.text = BMIComments.obese
            
        }else if bmi >= 39.9 {
            let adviseTap = UITapGestureRecognizer(target: self, action: #selector(CalculateBMIViewController.openNHSLink(sender:)))
            commentLabel.isUserInteractionEnabled = true
            commentLabel.addGestureRecognizer(adviseTap)
            commentLabel.text = BMIComments.extremelyObese
            
        }
        else {
            commentLabel.text = "no valid data"
        }
        
        
        
    }
    
    @IBAction func openURL(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toBMIChart", sender: self)
    }
    
    @objc func openNHSLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: nhsLink)!, options: [:], completionHandler: nil)
    }
    
    
}
