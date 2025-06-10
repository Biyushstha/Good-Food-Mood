//
//  HomeViewController.swift
//  Good Food Mood
//
//  Created by Biyush on 13/05/2025.
//

import PhotosUI
import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {


    private let homeView = HomeView()
    private let viewModel = HomeViewModel()
    private var selectedImage: UIImage? {
        didSet {
            homeView.imageView.image = selectedImage
            let enabled = selectedImage != nil
            homeView.analyzeButton.isEnabled = enabled
            homeView.analyzeButton.alpha = enabled ? 1.0 : 0.5
        }
    }

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupKeyboardHandling()
    }

    private func setupActions() {
        homeView.takePhotoButton.addTarget(
            self,
            action: #selector(didTapTakePhoto),
            for: .touchUpInside
        )

        homeView.choosePhotoButton.addTarget(
            self,
            action: #selector(didTapChoosePhoto),
            for: .touchUpInside
        )

        homeView.analyzeButton.addTarget(
            self,
            action: #selector(didTapAnalyze),
            for: .touchUpInside
        )
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            DispatchQueue.main.async {
                self?.selectedImage = image as? UIImage
            }
        }
    }


    // MARK: - Image Selection

    @objc private func didTapTakePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "Camera Not Available", message: "Try on a real device.")
            return
        }

        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func didTapChoosePhoto() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        selectedImage = info[.originalImage] as? UIImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    // MARK: - Analysis

    @objc private func didTapAnalyze() {
        guard let selected = selectedImage else { return }
        let apiKey = ""
        let notes = homeView.notesTextView.text ?? ""

        homeView.analyzeButton.setTitle("Analyzing...", for: .normal)
        homeView.analyzeButton.isEnabled = false

        viewModel.analyzeImage(selected, apiKey: apiKey, notes: notes) { [weak self] result in
            DispatchQueue.main.async {
                self?.homeView.analyzeButton.setTitle("Analyze", for: .normal)
                self?.homeView.analyzeButton.isEnabled = true

                switch result {
                case .success(let foodResult):
                    let resultVC = ResultViewController(result: foodResult)
                    self?.present(resultVC, animated: true)

                case .failure(let error):
                    self?.showAlert(title: "Analysis Failed", message: error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Keyboard Handling

    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard homeView.notesTextView.isFirstResponder,
              let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let bottomPadding: CGFloat = 24
        let moveUp = keyboardFrame.height - bottomPadding

        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -moveUp)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Alert

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
