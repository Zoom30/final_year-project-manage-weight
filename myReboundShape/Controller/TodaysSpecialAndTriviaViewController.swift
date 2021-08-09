//
//  TodaysSpecialAndTriviaViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 04/03/2021.
//

import UIKit
import RealmSwift
class TodaysSpecialAndTriviaViewController: UIViewController {
    
    @IBOutlet weak var todaysSpecialLabel: UILabel!
    @IBOutlet weak var triviaLabel: UILabel!
    var accessToStoredSpecialMeal : Results<SpecialMealStored>?
    var generateWeeklyMeal = GenerateWeeklyMeal()
    let storedDate = UserDefaults.standard.object(forKey: "initialTime")
    let apiUrl = "https://api.spoonacular.com/mealplanner/generate?apiKey=9b901895edad45a483f3f7c377fd0ebf&timeFrame=day"
    let triviaApiUrl = "https://api.spoonacular.com/food/trivia/random?apiKey=9b901895edad45a483f3f7c377fd0ebf"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        checkTimeAndFetch()
        generateWeeklyMeal.fetchTriviaData(completionHandler: { (response) in
            DispatchQueue.main.async {
                self.triviaLabel.text = response.text
            }
            
        }, url: triviaApiUrl)
        
        
    }
    
    
    
    @IBAction func clickForMorePressed(_ sender: UIButton) {
        loadData()
        let urlToOpen = (accessToStoredSpecialMeal?.first?.url)!
        UIApplication.shared.open(URL(string: urlToOpen)!, options: [:], completionHandler: nil)
    }
    
    func loadData(){
        if let realm = try? Realm(){
            accessToStoredSpecialMeal = realm.objects(SpecialMealStored.self)
        }
    }
    
    func checkTimeAndFetch(){
        let differenceInTime = Calendar.current.dateComponents([.hour, .minute, .second], from: storedDate as! Date, to: Date())
        if differenceInTime.hour! > 23 {
            let randomInt = Int.random(in: 0...2)
            generateWeeklyMeal.fetchSpecialMealData(completionHandler: { (response) in
                DispatchQueue.main.async {
                    let specialMeal = SpecialMealStored()
                    specialMeal.title = response.meals[randomInt].title
                    specialMeal.url = response.meals[randomInt].sourceURL
                    let realm = try! Realm()
                    let updatedSpecialMeal = realm.objects(SpecialMealStored.self).first
                    try! realm.write{
                        updatedSpecialMeal?.title = specialMeal.title
                        updatedSpecialMeal?.url = specialMeal.url
                    }
                    self.todaysSpecialLabel.text = updatedSpecialMeal?.title
                }
            }, url: apiUrl)
            UserDefaults.standard.setValue(Date(), forKey: "initialTime")
        }
        else{
            let realm = try! Realm()
            let specialStoredMeal = realm.objects(SpecialMealStored.self).first
            todaysSpecialLabel.text = specialStoredMeal?.title
        }
    }
    
    
    @IBAction func generateNewTriviaPressed(_ sender: UIButton) {
        generateWeeklyMeal.fetchTriviaData(completionHandler: { (response) in
            DispatchQueue.main.async {
                self.triviaLabel.text = response.text
            }
        }, url: triviaApiUrl)
    }
    
    
    
}
