//
//  ResultViewController.swift
//  Good Food Mood
//
//  Created by Biyush on 13/05/2025.
//

import UIKit

import UIKit

class ResultViewController: UIViewController {

    private let resultView = ResultView()
    private let result: FoodAnalysisResult

    init(result: FoodAnalysisResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = resultView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.configure(with: result)
        resultView.tryAgainButton.addTarget(self, action: #selector(didTapTryAgain), for: .touchUpInside)
    }

    @objc private func didTapTryAgain() {
        dismiss(animated: true)
    }
}

