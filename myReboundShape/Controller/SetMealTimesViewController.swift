//
//  SetMealTimesViewController.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 21/01/2021.
//

import UIKit

class SetMealTimesViewController: UIViewController {

    @IBOutlet var uiDatePickerCollection: [UIDatePicker]!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        let breakfastTime = formatter.string(from: uiDatePickerCollection[0].date)
        let lunchTime = formatter.string(from: uiDatePickerCollection[1].date)
        let dinnerTime = formatter.string(from: uiDatePickerCollection[2].date)
        scheduleNotificationForBreakFast()
        scheduleNotificationForLunch()
        scheduleNotificationForDinner()
        let message = "Reminder is set for: \(breakfastTime) for breakfast. \(lunchTime) for lunch. \(dinnerTime) for dinner"
        let alert = UIAlertController(title: "Confirmation", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetNotificationsPressed(_ sender: UIButton) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["identifierForBreakfast", "identifierForLunch", "identifierForDinner"])
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        
        
        
        
        
        let message = "Reminders are cancelled"
        let alert = UIAlertController(title: "Reminder reset", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    

    func scheduleNotificationForBreakFast() {
        let content = UNMutableNotificationContent()
        content.title = "Good morning, Breakfast Reminder"
        content.body = "Check your weekly meal plan for options"
        content.categoryIdentifier = "alarm"
   //     content.userInfo = ["customeData" : "fizzbuzz"]
        content.sound = UNNotificationSound.default
        let dateComponent = uiDatePickerCollection[0].calendar.dateComponents([.hour, .minute], from: uiDatePickerCollection[0].date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let notificationReq = UNNotificationRequest(identifier: "identifierForBreakfast", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(notificationReq, withCompletionHandler: nil)
      
    }

    
    func scheduleNotificationForLunch() {
        let content = UNMutableNotificationContent()
        content.title = "Lunch Reminder"
        content.body = "Check your weekly meal plan for options"
        content.categoryIdentifier = "alarm"
    //    content.userInfo = ["customeData" : "fizzbuzz"]
        content.sound = UNNotificationSound.default
        let dateComponent = uiDatePickerCollection[1].calendar.dateComponents([.hour, .minute], from: uiDatePickerCollection[1].date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let notificationReq = UNNotificationRequest(identifier: "identifierForLunch", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(notificationReq, withCompletionHandler: nil)
    }


    func scheduleNotificationForDinner() {
        let content = UNMutableNotificationContent()
        content.title = "Good evening, Dinner reminder"
        content.body = "Check your weekly meal plan for options"
        content.categoryIdentifier = "alarm"
     //   content.userInfo = ["customeData" : "fizzbuzz"]
        content.sound = UNNotificationSound.default
        let dateComponent = uiDatePickerCollection[2].calendar.dateComponents([.hour, .minute], from: uiDatePickerCollection[2].date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let notificationReq = UNNotificationRequest(identifier: "identifierForDinner", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(notificationReq, withCompletionHandler: nil)
    }

}
