//
//  CalorieResultsViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 23/02/2021.
//

import UIKit

class CalorieResultsViewController: UIViewController {
    @IBOutlet weak var maintainWeightCalorieLabel: UILabel!
    
    @IBOutlet weak var mildWeightLossCalorieLabel: UILabel!
    @IBOutlet weak var normalWeightLossCalorieLabel: UILabel!
    @IBOutlet weak var extremeWeightLossCalorieLabel: UILabel!
    
    @IBOutlet weak var mildWeightGainCalorieLabel: UILabel!
    @IBOutlet weak var normalWeightGainCalorieLabel: UILabel!
    @IBOutlet weak var fastWeightGainCalorieLabel: UILabel!
    
    
    
    var maintainWeight = ""
    
    var mildWeightLoss = ""
    var normalWeightLoss = ""
    var extremeWeightLoss = ""
    
    var mildWeightGain = ""
    var normalWeightGain = ""
    var fastWeightGain = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        maintainWeightCalorieLabel.text = maintainWeight
        
        mildWeightLossCalorieLabel.text = mildWeightLoss
        normalWeightLossCalorieLabel.text = normalWeightLoss
        extremeWeightLossCalorieLabel.text = extremeWeightLoss
        
        mildWeightGainCalorieLabel.text = mildWeightGain
        normalWeightGainCalorieLabel.text = normalWeightGain
        fastWeightGainCalorieLabel.text = fastWeightGain

    }
    
    
    @IBAction func returnButtonPressed(_ sender: UIButton) {
        show(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Required Calorie Calculator"), sender: self)
        
    }
    
}
