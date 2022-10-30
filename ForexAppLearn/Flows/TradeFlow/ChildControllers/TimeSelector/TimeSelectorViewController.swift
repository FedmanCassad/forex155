//
//  PairsSelectorViewController.swift
//  Quotex
//

import UIKit

protocol TimeSelectorDelegate: AnyObject {
    func didSelectTime(ofTotal seconds: Int)
}

final class TimeSelectorViewController: DefaultViewController {
    
    let minutes: [String] = ["0", "1", "2", "3", "4", "5"]
    let seconds: [String] = {
        var seconds = [String]()
        for i in 0...60 {
            seconds.append("\(i)")
        }
        return seconds
    }()

    weak var delegate: TimeSelectorDelegate?
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
    
    private let timeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interMedium(size: 18)
        label.text = R.string.localizable.time()
        label.textColor = .white
        return label
    }()

    private lazy var timeTextField: UITextField = {
        let textField = InaccessibleTextField()
        textField.layer.cornerRadius = 4
        textField.backgroundColor = UIColor(hex: "090B11")
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor(hex: "BABCC3", alpha: 0.4).cgColor
        textField.text = "00:30"
//        textField.delegate = self
        textField.textColor = .white
//        textField.isEnabled = false
//        textField.addTarget(self, action: #selector(timeFieldDidTapped), for: .touchDown)
        return textField
    }()
    
    private lazy var timePicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor(hex: "151515", alpha: 0.85)
        return  pickerView
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
        button.backgroundColor = .white
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
        timePicker.selectRow(30, inComponent: 1, animated: false)
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
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.timePicker.snp.remakeConstraints { make in
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(250.fitH)
                    make.bottom.equalTo(self.view.snp.bottom)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func addSubviews() {
        view.addSubview(blurView)
        blurView.contentView.addSubview(shapeView)
        shapeView.addSubview(timeTitleLabel)
        shapeView.addSubview(timeTextField)
        shapeView.addSubview(cancelButton)
        shapeView.addSubview(okButton)
        view.addSubview(timePicker)
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
        
        timeTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        
        timeTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24.fitW)
            make.height.equalTo(56)
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(12)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24.fitW)
            make.height.equalTo(56)
            make.top.equalTo(timeTextField.snp.bottom).offset(16)
            make.width.equalTo((view.bounds.width - 104.fitW) / 2)
        }
        
        okButton.snp.makeConstraints { make in
            make.leading.equalTo(cancelButton.snp.trailing).offset(8.fitW)
            make.height.equalTo(56)
            make.trailing.equalToSuperview().inset(24.fitW)
            make.centerY.equalTo(cancelButton)
        }
        
        timePicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250.fitH)
            make.top.equalTo(view.snp.bottom)
        }
    }
    
    @objc private func okButtonTapped() {
        guard
            let minutes = Int(minutes[timePicker.selectedRow(inComponent: 0)]),
            let seconds = Int(seconds[timePicker.selectedRow(inComponent: 1)])
        else { return }
        print("Seconds selected \(seconds)")
        let totalSeconds = minutes * 60 + seconds
        print(totalSeconds)
        delegate?.didSelectTime(ofTotal: totalSeconds)
        dismissController()
    }
    
    private func dismissController() {
        timePicker.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250.fitH)
            make.top.equalTo(view.snp.bottom)
        }
        
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

extension TimeSelectorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = ""
        if component == 0 {
            string = minutes[row]
        } else {
            string = seconds[row]
        }
        let attrTitle = NSAttributedString(
            string: string,
            attributes: [
                .foregroundColor: UIColor.white
            ]
        )
        return attrTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return minutes.count
        } else {
            return seconds.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedMinutes = Int(minutes[pickerView.selectedRow(inComponent: 0)]) ?? 0
        let selectedSeconds = Int(seconds[pickerView.selectedRow(inComponent: 1)]) ?? 0
        
        if selectedMinutes * 60 + selectedSeconds > 300 {
            pickerView.selectRow(5, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            timeTextField.text = "05:00"
        } else if selectedMinutes * 60 + selectedSeconds < 30 {
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.selectRow(30, inComponent: 1, animated: true)
            timeTextField.text = "00:30"
        } else {
            var minutes = String(selectedMinutes)
            var seconds = String(selectedSeconds)
            
            minutes = "0" + minutes
            if selectedSeconds < 10 {
                seconds = "0" + seconds
            }
            timeTextField.text = "\(minutes):\(seconds)"
        }
    }
}
