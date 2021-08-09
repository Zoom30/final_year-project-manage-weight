//
//  WLPViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 18/02/2021.
//

import UIKit
import RealmSwift
class WLPViewController: UIViewController {
    @IBOutlet weak var currentWeightMiniLabel: UILabel!
    @IBOutlet weak var targetWeightMiniLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!
    
    
    var accessToInitialWeight : Results<InitialWeightAndHeight>?
    var accessToTargetWeight : Results<SetTargetWeight>?
    override func viewDidLoad() {
        super.viewDidLoad()
        disclaimerLabel.text = Disclaimer.disclaimer
         loadData()
         
         currentWeightMiniLabel.text = String("\(accessToInitialWeight![0].weight) kg")
         targetWeightMiniLabel.text = String("\(accessToTargetWeight![0].targetWeight) kg")
         let value = UIInterfaceOrientation.portrait.rawValue
         UIDevice.current.setValue(value, forKey: "orientation")

    }
    
    func loadData(){
        if let realm = try? Realm(){
            accessToInitialWeight = realm.objects(InitialWeightAndHeight.self)
            accessToTargetWeight = realm.objects(SetTargetWeight.self)
        }
        
    }
    
    
    @IBAction func weightTrackerPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toWeightTrackerFromWLP", sender: self)
    }
    
    @IBAction func calculateBMIPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toCalculateBMIFromWLP", sender: self)
    }
    
    @IBAction func setTargetWeightPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toUpdateWeightTrackerFromWLP", sender: self)
    }
    
    @IBAction func weeklyMealRoutinePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toWeeklyMealRoutineFromWLP", sender: self)
    }
    
    @IBAction func setMealReminderPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toSetMealReminderFromWLP", sender: self)
    }
    
    @IBAction func calorieRequireCalcPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toRequiredCalorieCalculatorFromWLP", sender: self)
    }
    
    
    
}
