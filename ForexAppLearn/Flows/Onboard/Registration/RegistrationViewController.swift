
import PhotosUI
import UIKit

final class RegistrationViewController: DefaultViewController {
    
    var finishHandler: (() -> Void)?
    
    let networkService = NetEngine()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.registrationBackground()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.interMedium(size: 24)
        label.text = R.string.localizable.registration()
        label.textAlignment = .center
        return label
    }()
    
    private let shapeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.avatarPlaceholder()
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    private let editButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.editAvatar()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.9)
        label.font = R.font.interRegular(size: 16)
        label.text = R.string.localizable.registrationSubtitle()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var chooseCountryButton: RegistrationButton = {
        let button = RegistrationButton(type: .system)
        var title = "USA"
        if Locale.current.languageCode == "ru" {
            title = "Russian Federation"
            selectedCountry = CountryModel.allCountries.first(where: { $0.langCode == "ru"} )
        } else if Locale.current.languageCode == "en" {
            title = "USA"
            selectedCountry = CountryModel.allCountries.first(where: { $0.langCode == "us"} )
        }
        button.setTitle(title, for: .normal)
        return button
    }()
    
    private lazy var nicknameField: UITextField = {
        let textField  = UITextField()
        textField.backgroundColor = .clear
        let attrPlaceHolder = NSAttributedString(
            string: R.string.localizable.yourNickname(),
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.5)
            ]
        )
        textField.attributedPlaceholder = attrPlaceHolder
        textField.delegate = self
        textField.textColor = .white
        textField.addTarget(self, action: #selector(handleNicknameInput), for: .editingChanged)
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    var selectedCountry: CountryModel?
    
    let nextButton = UIButton.makeOnboardingButton(with: R.string.localizable.buttonNextTitle())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        nextButton.isEnabled = false
        nextButton.backgroundColor = .lightGray
    }
    
    override func addSubviews() {
        view.addSubview(backgroundImage)
        backgroundImage.addSubview(titleLabel)
        backgroundImage.addSubview(subtitleLabel)
        backgroundImage.addSubview(shapeView)
        shapeView.addSubview(blurView)
        blurView.contentView.addSubview(avatarImage)
        blurView.contentView.addSubview(editButton)
        blurView.contentView.addSubview(chooseCountryButton)
        blurView.contentView.addSubview(nicknameField)
        blurView.contentView.addSubview(nextButton)
    }
    
    // MARK: -  Actions
    private func setupActions() {
        chooseCountryButton.addTarget(self, action: #selector(showCountrySelector), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(askToNextStep), for: .touchUpInside)
        avatarImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPhotoPicker)))
        editButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPhotoPicker)))
    }
    
    @objc private func showCountrySelector() {
        let countrySelector = CountrySelectorViewController()
        countrySelector.modalPresentationStyle = .overFullScreen
        countrySelector.delegate = self
        present(countrySelector, animated: false)
    }
    
    @objc private func showPhotoPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .compatible
        let phPicker = PHPickerViewController(configuration: configuration)
        phPicker.delegate = self
        present(phPicker,animated: true)
    }
    
    @objc private func askToNextStep() {
        guard
            let name = nicknameField.text,
            let avatar = avatarImage.image else
        {
            return
        }
        networkService.submitUser(with: name, avatar: avatar) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.showSimpleAlert(with: "Error submitting user")
                }
            case .success(let userResponse):
                let user = userResponse.user
                print(user)
                if user.isUserExists {
                    DispatchQueue.main.async {
                        self?.showSimpleAlert(with: R.string.localizable.errorUserExists())
                    }
                    return
                }
                UserLocalSettings.user = user
                DispatchQueue.main.async {
                    UserLocalSettings.didShowOnboarding = true
                    self?.finishHandler?()
                }
            }
        }
    }
    
    override func setupAppearance() {
        view.backgroundColor = .clear
    }
    
    override func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
 
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(71.fitH)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        shapeView.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(380)
            make.centerX.centerY.equalToSuperview()
        }
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        avatarImage.snp.makeConstraints { make in
            make.height.width.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.bottom.trailing.equalTo(avatarImage)
        }
        
        chooseCountryButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameField.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        nicknameField.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(32)
            make.height.equalTo(56)
            make.top.equalTo(avatarImage.snp.bottom).offset(16)
        }
        
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(chooseCountryButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 20
    }
    
    @objc private func handleNicknameInput() {
        guard let text = nicknameField.text else { return }
        nextButton.isEnabled = text.count > 4
        nextButton.backgroundColor = text.count > 4 ? UIColor(hex: "F1CB2F") : .lightGray
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegistrationViewController: CountrySelectorDelegate {
    func countryDidSelected(country: CountryModel) {
        selectedCountry = country
        chooseCountryButton.setTitle(country.title, for: .normal)
        UserLocalSettings.selectedCountry = country
    }
}

extension RegistrationViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler:  { [weak self]  (object, error) in
                if let error = error {
                    print(error)
                }
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.avatarImage.image = image
                    }
                }
            }
            )
        }
    }
}
