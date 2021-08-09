//
//  WeightTrackerViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 25/01/2021.
//

import UIKit
import RealmSwift
class WeightTrackerViewController: UIViewController {
    @IBOutlet weak var weightUnitTypeSwitch: UISegmentedControl!
    @IBOutlet weak var updateTextLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progressWheelView: ProgressViewUIView!
    
    
    //@IBOutlet weak var progressToTargetView: UIProgressView!
    
    
    var accessToInitialWeightAndHeight : Results<InitialWeightAndHeight>?
    var accessToTargetWeight : Results<SetTargetWeight>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTargetWeightData()
        loadInitialWeightAndHeightData()
        
        progressWheelView.drawShape()
        let targetKgValue = accessToTargetWeight![0].targetWeight
        let initialKgValue = accessToInitialWeightAndHeight![0].weight
        updateTextLabel.text = "You are \(String(format: "%.2f", targetKgValue - initialKgValue)) kg away from your target weight of \(targetKgValue) kg now"
        
        
        var finalLabel = 0.0
        var updateLabelBy = 0.0
        
        if initialKgValue <= targetKgValue {
            let maxPercent = initialKgValue/targetKgValue * 100
            for percent in 0...Int(maxPercent){
                Timer.scheduledTimer(withTimeInterval: 0.025 * updateLabelBy, repeats: false) { (timer) in
                    finalLabel = Double(percent)
                    self.percentLabel.text = "\(String(Int(finalLabel))) %"
                }
                updateLabelBy += 1
            }
            
        }
        
        
        else if initialKgValue > targetKgValue{
            let maxPercent = targetKgValue/initialKgValue * 100
            
            for percent in 0...Int(maxPercent){
                Timer.scheduledTimer(withTimeInterval: 0.025 * updateLabelBy, repeats: false) { (timer) in
                    finalLabel = Double(percent)
                    self.percentLabel.text = "\(String(Int(finalLabel))) %"
                }
                updateLabelBy += 1
            }
        }
        
    }
    
    
    
    
    
    func loadInitialWeightAndHeightData() {
        if let realm = try? Realm(){
            accessToInitialWeightAndHeight = realm.objects(InitialWeightAndHeight.self)
        }
    }
    
    func loadTargetWeightData(){
        if let realm = try? Realm(){
            accessToTargetWeight = realm.objects(SetTargetWeight.self)
        }
    }
    
    
    
    
    @IBAction func weightUnitChanged(_ sender: UISegmentedControl) {
        
        let initialKgValue = accessToInitialWeightAndHeight![0].weight
        let initialPoundValue = initialKgValue * 2.205
        let targetKgValue = accessToTargetWeight![0].targetWeight
        let targetPoundValue = targetKgValue * 2.205
        
        if weightUnitTypeSwitch.selectedSegmentIndex == 0 {
            updateTextLabel.text = "You are \(String(format: "%.2f", targetKgValue - initialKgValue)) kgs away from your target weight of \(targetKgValue) kgs now"
        }
        if weightUnitTypeSwitch.selectedSegmentIndex == 1 {
            updateTextLabel.text = "You are \(String(format: "%.2f", (targetPoundValue - initialPoundValue))) lbs away from your target weight of \(String(format: "%.2f", (targetPoundValue))) lbs now"
        }
        
    }
    
    
    
    
    @IBAction func updateCurrentWeightPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toUpdateCurrentWeight", sender: self)
    }
    
    
    
    
    @IBAction func viewWeightHistoryPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toWeightHistory", sender: self)
    }
    
    
    
}
