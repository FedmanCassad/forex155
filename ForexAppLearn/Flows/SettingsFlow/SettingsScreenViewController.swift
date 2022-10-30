
import UIKit
import PhotosUI
import StoreKit
import MessageUI

final class SettingsScreenViewController: DefaultViewController {
    private let service = NetEngine()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "080B14", alpha: 0.94)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.interMedium(size: 18)
        label.text = R.string.localizable.tabBarSettingsTitle()
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.image = R.image.avatarPlaceholder()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interMedium(size: 16)
        label.textColor = .white
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 13)
        label.textColor = .white.withAlphaComponent(0.5)
        label.text = UserLocalSettings.selectedCountry.title
        return label
    }()
    
    private let setupButton: UIButton = {
        let button = UIButton(type: .system)
        let attrTitle = NSAttributedString(
            string: R.string.localizable.buttonSetupTitle().uppercased(),
            attributes: [
                .font: R.font.interRegular(size: 12) ?? .systemFont(ofSize: 12),
                .foregroundColor: UIColor(hex: "3789E2")
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageView?.tintColor = .white
        return button
    }()
    
    private let firstSeparatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "BABCC3", alpha: 0.4)
        return view
    }()
    
    private let secondSeparatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "BABCC3", alpha: 0.4)
        return view
    }()
    
    private let thirdSeparatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "BABCC3", alpha: 0.4)
        return view
    }()
    
    private let writeToSupportButton: UIButton = {
        let button = SettingsButton(type: .system)
        let attrTitle = NSAttributedString(
            string: R.string.localizable.settingsWriteToSupport(),
            attributes: [
                .font: R.font.interRegular(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.setImage(R.image.settingsLetterIcon(), for: .normal)
        return button
    }()
    
    private let ratetheAppButton: UIButton = {
        let button = SettingsButton(type: .system)
        let attrTitle = NSAttributedString(
            string: R.string.localizable.settingsRateTheApp(),
            attributes: [
                .font: R.font.interRegular(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.setImage(R.image.settingsStarIcon(), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupActions()
    }
    
    override func addSubviews() {
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        view.addSubview(avatarImageView)
        view.addSubview(userNameLabel)
        view.addSubview(countryLabel)
        view.addSubview(setupButton)
        view.addSubview(firstSeparatorLineView)
        view.addSubview(writeToSupportButton)
        view.addSubview(secondSeparatorLineView)
        view.addSubview(ratetheAppButton)
        view.addSubview(thirdSeparatorLineView)
    }
    
    private func updateUI() {
        guard let user = UserLocalSettings.user else { return }
        userNameLabel.text = user.name
        if let url = user.avatar {
            avatarImageView.kf.setImage(with: url)
        }
        countryLabel.text = UserLocalSettings.selectedCountry.title
    }
    
    private func setupActions() {
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPicker)))
        setupButton.addTarget(self, action: #selector(showNameChangeAlert), for: .touchUpInside)
        ratetheAppButton.addTarget(self, action: #selector(requestReview), for: .touchUpInside)
        writeToSupportButton.addTarget(self, action: #selector(showMail), for: .touchUpInside)
    }
    
    @objc private func requestReview() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
    
    @objc private func showMail() {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients(["mickh4ilov@yandex.ru"])
            mailController.setMessageBody(
                "<p> Hey! I need some help!</p>", isHTML: true
            )
            mailController.setSubject("Here are my questions:")
            present(mailController, animated: true)
        } else {
            print("Cant send an e-mail")
        }
    }
    
    @objc private func showPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .compatible
        let phPicker = PHPickerViewController(configuration: configuration)
        phPicker.delegate = self
        present(phPicker,animated: true)
    }
    
    @objc private func showNameChangeAlert() {
        let controller = UIAlertController(title: "Edit your name", message: "Enter new name here", preferredStyle: .alert)
        controller.addTextField() { field in
            field.delegate = self
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
//            controller.dismiss(animated: true)
        }
        
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] alert in
            guard
                let newUserName = controller.textFields?.first?.text,
                let image = self?.avatarImageView.image else {
                return
            }
            guard newUserName.count > 4 else { return }
            self?.service.updateUserAvatarAndName(with: image, name: newUserName) { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let response):
                    UserLocalSettings.user = response.user
                    DispatchQueue.main.async {
                        self?.updateUI()
                    }
                }
            }
        }
        controller.addAction(cancelAction)
        controller.addAction(action)
        present(controller, animated: true)
    }
    
    override func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(94.fitH)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(headerView.snp.bottom).offset(16)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(avatarImageView.snp.centerY).inset(1)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(18)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.leading.equalTo(userNameLabel)
            make.top.equalTo(userNameLabel.snp.bottom).offset(2)
        }
        
        setupButton.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
            make.trailing.equalToSuperview().inset(24)
        }
        
        firstSeparatorLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
        }
        
        writeToSupportButton.snp.makeConstraints { make in
            make.top.equalTo(firstSeparatorLineView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        
        secondSeparatorLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(writeToSupportButton.snp.bottom)
        }
        
        ratetheAppButton.snp.makeConstraints { make in
            make.top.equalTo(secondSeparatorLineView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        
        thirdSeparatorLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(ratetheAppButton.snp.bottom)
        }
    }
}

extension SettingsScreenViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        // Use UIImage
                        self?.service.updateUserAvatar(with: image) { result in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(let response):
                                UserLocalSettings.user = response.user
                                DispatchQueue.main.async {
                                    self?.updateUI()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension SettingsScreenViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 20
    }
}

extension SettingsScreenViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
