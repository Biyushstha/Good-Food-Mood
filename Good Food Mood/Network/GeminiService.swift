//
//  GeminiService.swift
//  Good Food Mood
//
//  Created by Biyush on 15/05/2025.
//

import UIKit

final class GeminiService {
    private let modelEndpoint = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent"

    func analyzeFoodImage(_ image: UIImage, apiKey: String, notes: String, completion: @escaping (Result<FoodAnalysisResult, Error>) -> Void) {
        guard let imageData = image.resized(toWidth: 512)?.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Encoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not encode image"])))
            return
        }

        let base64 = imageData.base64EncodedString()

        let prompt = """
        You are a food analysis assistant. Analyze the attached image and estimate:

        - The food name
        - The visible portion (e.g., half bowl, one slice)
        - The estimated weight in grams (if possible)
        - Calories, protein, fat, and carbs — based only on what’s visible in the image
        
        If user-provided notes are available, incorporate them to improve accuracy.

        User notes: "\(notes)"

        Respond only in JSON. Format:

        Respond only in JSON. Do not explain anything. Format:

        {
          "food_name": "Pasta with tomato sauce",
          "portion_estimate": "half plate",
          "weight_estimate_grams": 160,
          "calories": 280,
          "protein": 12,
          "fat": 6,
          "carbs": 40
        }
        """

        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt],
                        ["inline_data": [
                            "mime_type": "image/jpeg",
                            "data": base64
                        ]]
                    ]
                ]
            ]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "Encoding", code: 1, userInfo: nil)))
            return
        }

        guard let url = URL(string: "\(modelEndpoint)?key=\(apiKey)") else {
            completion(.failure(NSError(domain: "BadURL", code: 2, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let candidates = root["candidates"] as? [[String: Any]],
                  let content = candidates.first?["content"] as? [String: Any],
                  let parts = content["parts"] as? [[String: Any]],
                  let responseText = parts.first?["text"] as? String
            else {
                completion(.failure(NSError(domain: "ParseError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                return
            }

            if let jsonStart = responseText.range(of: "{"),
               let jsonEnd = responseText.range(of: "}", options: .backwards) {
                let jsonString = String(responseText[jsonStart.lowerBound...jsonEnd.upperBound])
                if let jsonData = jsonString.data(using: .utf8),
                   let result = try? JSONDecoder().decode(FoodAnalysisResult.self, from: jsonData) {
                    completion(.success(result))
                    return
                }
            }

            completion(.failure(NSError(domain: "ParseError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Could not decode Gemini output"])))
        }.resume()
    }
}

// MARK: - Image Resize Helper
extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let scale = width / self.size.width
        let height = self.size.height * scale
        let newSize = CGSize(width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized
    }
}
