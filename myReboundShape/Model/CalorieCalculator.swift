//
//  CalorieCalculator.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 23/02/2021.
//

import Foundation
class CalculateCalorie {
    
    
    func calculate (age : Int, gender : Int, height : Double, weight: Double, activityLevel : Int) -> Double{
        var BMR = 0.0
        if gender == 0{
            if activityLevel == 0 {
                BMR = ((10.0 * weight) + (6.25 * height) - Double((5 * age)) + 5.0)
                return BMR
            }
            else if activityLevel == 1 {
                BMR = ((10.0 * weight) + (6.25 * height) - Double((5 * age)) + 5.0) * 1.2
                return BMR
            }else if activityLevel == 2 {
                BMR = ((10.0 * weight) + (6.25 * height) - Double((5 * age)) + 5.0) * 1.375
                return BMR
            }else if activityLevel == 3 {
                BMR = ((10.0 * weight) + (6.25 * height) - Double((5 * age)) + 5.0) * 1.55
                return BMR
            }else if activityLevel == 4 {
                BMR = ((10.0 * weight) + (6.25 * height) - Double((5 * age)) + 5.0) * 1.725
                return BMR
            }else if activityLevel == 5 {
                BMR = ((10.0 * weight) + (6.25 * height) - Double((5 * age)) + 5.0) * 1.9
                return BMR
            }
            
        }
        else{
            if activityLevel == 0 {
                BMR = ((10.0 * weight) + (6.25 * height) - Double((5 * age)) - 161.0)
                return BMR
            }
            else if activityLevel == 1 {
                BMR = ((10.0 * weight) + (6.25 * height) - Double((5 * age)) - 161.0) * 1.2
                return BMR
            }else if activityLevel == 2 {
                BMR = ((10.0 * weight) + (6.25 * height) - Double((5 * age)) - 161.0) * 1.375
                return BMR
            }else if activityLevel == 3 {
                BMR = ((10.0 * weight) + (6.25 * height) - Double((5 * age)) - 161.0) * 1.55
                return BMR
            }else if activityLevel == 4 {
                BMR = ((10.0 * weight) + (6.25 * height) - Double((5 * age)) - 161.0) * 1.725
                return BMR
            }else if activityLevel == 5 {
                BMR = ((10.0 * weight) + (6.25 * height) - Double((5 * age)) - 161.0) * 1.9
                return BMR
            }
        }
        return 0.0
    }
    
}
