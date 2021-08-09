//
//  Weekly Meal Generator.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 21/02/2021.
//

import Foundation


class GenerateWeeklyMeal {
    func fetchPostData(completionHandler : @escaping (MealAPIResponse) -> Void, url : String) {
        let url = URL(string: url)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let postsData = try JSONDecoder().decode(MealAPIResponse.self, from: data)
                completionHandler(postsData)
            }catch{
                let error = error
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    func fetchTriviaData(completionHandler : @escaping (Trivia) -> Void, url : String) {
        let url = URL(string: url)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let postsData = try JSONDecoder().decode(Trivia.self, from: data)
                completionHandler(postsData)
            }catch{
                let error = error
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    struct TodaysSpecial: Codable {
        let meals: [Meal]
        let nutrients: Nutrients
    }

    struct Meal: Codable {
        let id: Int
        let imageType, title: String
        let readyInMinutes, servings: Int
        let sourceURL: String

        enum CodingKeys: String, CodingKey {
            case id, imageType, title, readyInMinutes, servings
            case sourceURL = "sourceUrl"
        }
    }

    struct Nutrients: Codable {
        let calories, protein, fat, carbohydrates: Double
    }
    
    
    func fetchSpecialMealData(completionHandler : @escaping (TodaysSpecial) -> Void, url : String) {
        let url = URL(string: url)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let postsData = try JSONDecoder().decode(TodaysSpecial.self, from: data)
                completionHandler(postsData)
            }catch{
                let error = error
                print(error.localizedDescription)
            }
        }.resume()
    }
}
