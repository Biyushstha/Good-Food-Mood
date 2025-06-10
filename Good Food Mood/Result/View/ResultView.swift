//
//  ResultView.swift
//  Good Food Mood
//
//  Created by Biyush on 13/05/2025.
//

import UIKit

class ResultView: UIView {

    let titleLabel = UILabel()
    let caloriesLabel = UILabel()
    let proteinLabel = UILabel()
    let carbsLabel = UILabel()
    let fatLabel = UILabel()
    let tryAgainButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [titleLabel, caloriesLabel, proteinLabel, carbsLabel, fatLabel, tryAgainButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8


        [caloriesLabel, proteinLabel, carbsLabel, fatLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            $0.textAlignment = .center
        }

        tryAgainButton.setTitle("Try Another Photo", for: .normal)
        tryAgainButton.setTitleColor(.white, for: .normal)
        tryAgainButton.backgroundColor = .systemBlue
        tryAgainButton.layer.cornerRadius = 12
        tryAgainButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            caloriesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            caloriesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            caloriesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            proteinLabel.topAnchor.constraint(equalTo: caloriesLabel.bottomAnchor, constant: 16),
            proteinLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            proteinLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            carbsLabel.topAnchor.constraint(equalTo: proteinLabel.bottomAnchor, constant: 16),
            carbsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            carbsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            fatLabel.topAnchor.constraint(equalTo: carbsLabel.bottomAnchor, constant: 16),
            fatLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            fatLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            tryAgainButton.topAnchor.constraint(equalTo: fatLabel.bottomAnchor, constant: 32),
            tryAgainButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            tryAgainButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configure(with result: FoodAnalysisResult) {
        titleLabel.text = result.foodName
        caloriesLabel.text = "🔥 Calories: \(result.calories) kcal"
        proteinLabel.text = "💪 Protein: \(result.protein)g"
        carbsLabel.text = "🍚 Carbs: \(result.carbs)g"
        fatLabel.text = "🧈 Fat: \(result.fat)g"
    }
}

