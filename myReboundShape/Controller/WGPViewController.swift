//
//  ResultsViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 19/01/2021.
//

import UIKit
import RealmSwift
class WGPViewController: UIViewController {
    @IBOutlet weak var currentWeightMiniLabel: UILabel!
    @IBOutlet weak var targetWeightMiniLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!
    
    var accessToInitialWeight : Results<InitialWeightAndHeight>?
    var accessToTargetWeight : Results<SetTargetWeight>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        disclaimerLabel.text = Disclaimer.disclaimer
        currentWeightMiniLabel.text = String("\(accessToInitialWeight![0].weight) kg")
        targetWeightMiniLabel.text = String("\(accessToTargetWeight![0].targetWeight) kg")
       
    }

    //Segue functioning
    @IBAction func mealTimeReminderPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toSetMealTimes", sender: self)
    }
    
    
    //Segue functioning
    @IBAction func weightTrackerPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toWeightTrackerFromWGP", sender: self)
    }
    
    //Segue functioning
    @IBAction func calculateBMIPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toCalculateBMI", sender: self)
    }
    
    //Segue functioning
    @IBAction func updateCurrentWeightTargetPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toUpdateCurrentTargetWeight", sender: self)
    }
    
    //Segue functioning
    @IBAction func weeklyMealRoutinePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toWeeklyMealRoutine", sender: self)
    }
    
    //Segue functioning
    @IBAction func calorieCalculatorPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toRequiredCalorieCalculator", sender: self)        
    }
    
    func loadData(){
        if let realm = try? Realm(){
            accessToInitialWeight = realm.objects(InitialWeightAndHeight.self)
            accessToTargetWeight = realm.objects(SetTargetWeight.self)
        }
    }
    

}
