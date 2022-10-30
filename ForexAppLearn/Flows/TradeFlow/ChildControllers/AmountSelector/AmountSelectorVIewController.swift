
import UIKit

protocol AmountSelectorDelegate: AnyObject {
    func didSelectAmount(ofTotal amount: Int)
}

final class AmountSelectorViewController: DefaultViewController {

    weak var delegate: AmountSelectorDelegate?
    let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    let shapeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor(hex: "FF9933")
        return view
    }()
    
    private let amountTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interMedium(size: 18)
        label.textColor = .white
        return label
    }()

    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 4
        textField.backgroundColor = UIColor(hex: "090B11")
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor(hex: "BABCC3", alpha: 0.4).cgColor
        textField.placeholder = "$100"
        textField.delegate = self
        textField.textColor = .white
        textField.keyboardType = .numberPad
//        textField.isEnabled = false
//        textField.addTarget(self, action: #selector(timeFieldDidTapped), for: .touchDown)
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let attrTitle = NSAttributedString(
            string: R.string.localizable.cancel(),
            attributes: [
                .font: R.font.interMedium(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.layer.cornerRadius = 28
        button.backgroundColor = .white.withAlphaComponent(0.08)
        return button
    }()
    
    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        let attrTitle = NSAttributedString(
            string: "OK",
            attributes: [
                .font: R.font.interMedium(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.layer.cornerRadius = 28
        button.backgroundColor = UIColor.white
        return button
    }()
    
    override func setupAppearance() {
        view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appearAnimations()
    }
    
    private func setupActions() {
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func appearAnimations() {
        shapeView.snp.remakeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24.fitW)
            make.height.equalTo(206)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = 1
            self.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.amountTextField.becomeFirstResponder()
        }
    }
    
    override func addSubviews() {
        view.addSubview(blurView)
        blurView.contentView.addSubview(shapeView)
        shapeView.addSubview(amountTitleLabel)
        shapeView.addSubview(amountTextField)
        shapeView.addSubview(cancelButton)
        shapeView.addSubview(okButton)
    }
    
    @objc private func cancelButtonTapped() {
        dismissController()
    }
    
    override func setupConstraints() {
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        shapeView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(24.fitW)
            make.height.equalTo(206)
        }
        
        amountTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24.fitW)
            make.height.equalTo(56)
            make.top.equalTo(amountTitleLabel.snp.bottom).offset(12)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24.fitW)
            make.height.equalTo(56)
            make.top.equalTo(amountTextField.snp.bottom).offset(16)
            make.width.equalTo((view.bounds.width - 104.fitW) / 2)
        }
        
        okButton.snp.makeConstraints { make in
            make.leading.equalTo(cancelButton.snp.trailing).offset(8.fitW)
            make.height.equalTo(56)
            make.trailing.equalToSuperview().inset(24.fitW)
            make.centerY.equalTo(cancelButton)
        }
    }
    
    @objc private func okButtonTapped() {
        guard
            let text = amountTextField.text,
                let amount = Int(text)
        else { return }
        delegate?.didSelectAmount(ofTotal: amount)
        dismissController()
    }
    
    private func dismissController() {
        amountTextField.resignFirstResponder()
        shapeView.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(24.fitW)
            make.height.equalTo(206)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
}

extension AmountSelectorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
           let amount = Int(updatedText) ?? 0
        guard let user = UserLocalSettings.user else { return false }
        guard amount > 0 else { return false }
        return amount <= user.balance
    }
}
