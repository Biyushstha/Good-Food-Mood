//
//  FoodAnalysisResult.swift
//  Good Food Mood
//
//  Created by Biyush on 13/05/2025.
//

import Foundation

struct FoodAnalysisResult: Decodable {
    let foodName: String
    let calories: Int
    let protein: Int
    let fat: Int
    let carbs: Int

    enum CodingKeys: String, CodingKey {
        case foodName = "food_name"
        case calories
        case protein
        case fat
        case carbs
    }
}

