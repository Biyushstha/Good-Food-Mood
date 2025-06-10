import UIKit

class HomeView: UIView, UITextViewDelegate {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Good Food Mood"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        imageView.contentMode = .scaleAspectFit // ✅ Fix image distortion
        imageView.tintColor = .systemGray3
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()

    let takePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📸 Take Photo", for: .normal)
        button.backgroundColor = .systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        return button
    }()

    let choosePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🖼️ Choose Photo", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        return button
    }()

    let notesTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .label
        textView.backgroundColor = UIColor.systemGray6
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        textView.isScrollEnabled = false
        textView.text = ""
        return textView
    }()

    let notesPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "Additional info (e.g. protein powder, no butter)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .placeholderText
        label.numberOfLines = 2
        return label
    }()

    let analyzeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Analyze", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
        notesTextView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        [titleLabel, imageView, takePhotoButton, choosePhotoButton, notesTextView, notesPlaceholder, analyzeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            takePhotoButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            takePhotoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            takePhotoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            takePhotoButton.heightAnchor.constraint(equalToConstant: 48),

            choosePhotoButton.topAnchor.constraint(equalTo: takePhotoButton.bottomAnchor, constant: 12),
            choosePhotoButton.leadingAnchor.constraint(equalTo: takePhotoButton.leadingAnchor),
            choosePhotoButton.trailingAnchor.constraint(equalTo: takePhotoButton.trailingAnchor),
            choosePhotoButton.heightAnchor.constraint(equalToConstant: 48),

            notesTextView.topAnchor.constraint(equalTo: choosePhotoButton.bottomAnchor, constant: 20),
            notesTextView.leadingAnchor.constraint(equalTo: takePhotoButton.leadingAnchor),
            notesTextView.trailingAnchor.constraint(equalTo: takePhotoButton.trailingAnchor),
            notesTextView.heightAnchor.constraint(equalToConstant: 100),

            notesPlaceholder.topAnchor.constraint(equalTo: notesTextView.topAnchor, constant: 10),
            notesPlaceholder.leadingAnchor.constraint(equalTo: notesTextView.leadingAnchor, constant: 14),
            notesPlaceholder.trailingAnchor.constraint(equalTo: notesTextView.trailingAnchor, constant: -8),

            analyzeButton.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: 24),
            analyzeButton.leadingAnchor.constraint(equalTo: takePhotoButton.leadingAnchor),
            analyzeButton.trailingAnchor.constraint(equalTo: takePhotoButton.trailingAnchor),
            analyzeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        notesPlaceholder.isHidden = !textView.text.isEmpty
    }
}
