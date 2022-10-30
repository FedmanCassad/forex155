//
//  FinalController.swift
//  Quotex
//

import UIKit

final class PreFinalOnboardingController: DefaultViewController {
    
    var nextStepHandler: (() -> Void)?
    
    private let mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.prefinalMainImage()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interMedium(size: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.text = R.string.localizable.onboardingPrefinalTitle()
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = R.string.localizable.onboardingPrefinalSubtitle()
        return label
    }()
    
    private let nextButton = UIButton.makeOnboardingButton(with: R.string.localizable.buttonNextTitle())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    override func setupAppearance() {
        view.backgroundColor = UIColor(hex: "010811")
    }
    
    private func setupActions() {
        nextButton.addAction(
            UIAction { [weak self] _ in
                self?.nextStepHandler?()
            },
            for: .touchUpInside
        )
    }
    
    override func addSubviews() {
        view.addSubview(mainImage)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(nextButton)
    }
    
    override func setupConstraints() {
 
        mainImage.snp.makeConstraints { make in
            make.height.width.equalTo(250)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(196.fitH)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainImage.snp.bottom).offset(24.fitH)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(80.fitH)
        }
    }
}
