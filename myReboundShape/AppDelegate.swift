//
//  AppDelegate.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 18/01/2021.
//

import UIKit
import CoreData
import RealmSwift
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var generateWeeklyMeal = GenerateWeeklyMeal()
    let apiUrl = "https://api.spoonacular.com/mealplanner/generate?apiKey=9b901895edad45a483f3f7c377fd0ebf&timeFrame=day"

    var accessToSpecialMealStored : Results<SpecialMealStored>?
    func loadData(){
        if let realm = try? Realm(){
            accessToSpecialMealStored = realm.objects(SpecialMealStored.self)
        }
    }
    

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadData()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted{
                print("Notification Authorisation Granted")
            }else{
                print("Notification Authorisation Denied")
            }
        }
        
        
        if UserDefaults.standard.object(forKey: "initialTime") == nil {
            UserDefaults.standard.setValue(Date(), forKey: "initialTime")
            let storedDate = UserDefaults.standard.object(forKey: "initialTime") as! Date
            print("Initial time: \(storedDate)")
        }else{
            let storedDate = UserDefaults.standard.object(forKey: "initialTime") as! Date
            print("Initial time: \(storedDate)")
        }
        
      
        let randomInt = Int.random(in: 0...2)
        if accessToSpecialMealStored!.count == 0{
            generateWeeklyMeal.fetchSpecialMealData(completionHandler: { (response) in
                DispatchQueue.main.async {
                    let specialMeal = SpecialMealStored()
                    specialMeal.title = response.meals[randomInt].title
                    specialMeal.url = response.meals[randomInt].sourceURL
                    if let realm = try? Realm(){
                        try! realm.write{
                            realm.add(specialMeal)
                        }
                    }
                    
                }
            }, url: apiUrl)
        }
        
        
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
     
        
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "myReboundShape")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

