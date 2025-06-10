//
//  HomeViewModel.swift
//  Good Food Mood
//
//  Created by Biyush on 13/05/2025.
//

import UIKit

class HomeViewModel {

    private let gemini = GeminiService()

    func analyzeImage(
        _ image: UIImage,
        apiKey: String,
        notes: String,
        completion: @escaping (Result<FoodAnalysisResult, Error>) -> Void
    ) {
        gemini.analyzeFoodImage(image, apiKey: apiKey, notes: notes, completion: completion)
    }


}
