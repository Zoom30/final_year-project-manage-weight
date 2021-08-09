//
//  CalculateBMIViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 25/01/2021.
//

import UIKit
import RealmSwift
class CalculateBMIViewController: UIViewController {
    @IBOutlet weak var currentBMILabel: UILabel!
    @IBOutlet weak var bmiCommentLabel: UILabel!
    @IBOutlet weak var bmiMeter: UIProgressView!
    
    
    var accessToInitialWeightHeight : Results<InitialWeightAndHeight>?
    let nhsLink = "https://www.nhs.uk/conditions/obesity/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromInitialWeightAndHeight()
        let weight = accessToInitialWeightHeight![0].weight
        let height = accessToInitialWeightHeight![0].height
        let bmi = weight / (height * height)
        
     //   bmiMeter.progress = Float(bmi/50.0)
        UIView.animate(withDuration: 2){
            self.bmiMeter.setProgress(Float(bmi/50.0), animated: true)
            
        }
        
        if bmi < 18.5 {
            bmiCommentLabel.text = BMIComments.underweight
            bmiMeter.tintColor = .darkGray
        }else if bmi < 24.9 {
            bmiCommentLabel.text = BMIComments.normal
            bmiMeter.tintColor = .systemGreen
        }else if bmi < 29.9 {
            bmiCommentLabel.text = BMIComments.overweight
            bmiMeter.tintColor = .systemYellow
        }else if bmi < 39.9 {
            let adviseTap = UITapGestureRecognizer(target: self, action: #selector(openNHSLink(sender:)))
            bmiCommentLabel.isUserInteractionEnabled = true
            bmiCommentLabel.addGestureRecognizer(adviseTap)
            bmiCommentLabel.text = BMIComments.obese
            bmiMeter.tintColor = .systemRed
            
        }else if bmi >= 39.9 {
            let adviseTap = UITapGestureRecognizer(target: self, action: #selector(CalculateBMIViewController.openNHSLink(sender:)))
            bmiCommentLabel.isUserInteractionEnabled = true
            bmiCommentLabel.addGestureRecognizer(adviseTap)
            bmiCommentLabel.text = BMIComments.extremelyObese
            bmiMeter.tintColor = .black
            
        }
        else {
            bmiCommentLabel.text = "no valid data"
        }
            
            currentBMILabel.text = String(format: "%.2f", bmi)
        
        
        
    }
    
    func loadDataFromInitialWeightAndHeight(){
        if let realm = try? Realm(){
            accessToInitialWeightHeight = realm.objects(InitialWeightAndHeight.self)
        }
    }
    
    
    @IBAction func calculateCustomBMIPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toCalculateCustomBMI", sender: self)
    }
    
    @objc func openNHSLink (sender: UIGestureRecognizer){
        UIApplication.shared.open(URL(string: nhsLink)!, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func bmiChartButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toBMIChart", sender: self)
    }
    
    
}
