//
//  Weekly JSON model.swift
//  myReboundShape
//
//  Created by Daniel Ghebrat on 21/02/2021.
//

import Foundation


struct MealAPIResponse : Codable{
    var week : Week
}
struct Week: Codable {
    let monday, tuesday, wednesday, thursday: MealsAndNutrients
    let friday, saturday, sunday: MealsAndNutrients
}
struct MealsAndNutrients : Codable {
    var meals : [ThreePerDay]
    var nutrients : NutrientDetails
}
struct ThreePerDay : Codable {
    let id: Int
    let imageType: ImageType
    let title: String
    let readyInMinutes, servings: Int
    let sourceURL: String

    enum CodingKeys: String, CodingKey {
        case id, imageType, title, readyInMinutes, servings
        case sourceURL = "sourceUrl"
    }
}

enum ImageType: String, Codable {
    case jpeg = "jpeg"
    case jpg = "jpg"
    case png = "png"
}

struct NutrientDetails : Codable {
    let calories, protein, fat, carbohydrates: Double
}




struct Trivia: Codable {
    let text: String
}










