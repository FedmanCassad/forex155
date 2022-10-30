//
//  LeaderDetailsHeader.swift
//  Quotex
//
//  Created by Yaşar Ergin on 15.10.2022.
//

import UIKit

final class LeaderDetailsHeader: UICollectionReusableView {
    static let identifier = String(describing: LeaderDetailsHeader.self)
    
    private let resultingBalanceTitle: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 16)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = R.string.localizable.resultingBalance().uppercased()
        return label
    }()
    
    private let balanceValueLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interMedium(size: 32)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let comparisonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private let yourBalanceTitle: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 13)
        label.text = R.string.localizable.yourBalance()
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()
    
    private let yourBalanceValueLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 13)
        label.text = R.string.localizable.balance()
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()
    
    private let topTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 16)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = R.string.localizable.top().uppercased()
        return label
    }()
    
    private let topPositionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interMedium(size: 24)
        label.textColor = .white
        return label
    }()
    
    private let separatorLineView: UIView = {
         let view = UIView()
         view.backgroundColor = UIColor(hex: "BABCC3", alpha: 0.4)
         return view
     }()
    
    func makeStringForComparisonLabel(with model: Rating) -> NSAttributedString? {
        guard let user = UserLocalSettings.user else { return nil }
        let isHigher = user.balance < model.rate
        let color = isHigher ? UIColor(hex: "DE594C") : UIColor(hex: "56BB4D")
        let diff = abs(user.balance - model.rate)
        var string = ""
        if isHigher {
            string = R.string.localizable.on()
            + " "
            + "$"
            + "\(diff)"
            + " "
            + R.string.localizable.moreThan()
        } else {
           string = R.string.localizable.on()
            + " "
            + "$"
            + "\(diff)"
            + " "
            + R.string.localizable.lessThan()
        }
        
        let attrTitle = NSAttributedString(
            string: string,
            attributes: [
                .foregroundColor: color,
                .font: R.font.interRegular(size: 16) ?? .systemFont(ofSize: 16)
            ]
        )
        return attrTitle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Rating, position: Int) {
        balanceValueLabel.text = "$\(model.rate)"
        topPositionLabel.text = "№\(position)"
        comparisonLabel.attributedText = makeStringForComparisonLabel(with: model)
        guard let user = UserLocalSettings.user else { return }
        yourBalanceValueLabel.text = "$\(user.balance)"
    }
    
    private func setupSubviews() {
        addSubview(resultingBalanceTitle)
        addSubview(balanceValueLabel)
        addSubview(comparisonLabel)
        addSubview(yourBalanceTitle)
        addSubview(balanceValueLabel)
        addSubview(topTitleLabel)
        addSubview(topPositionLabel)
        addSubview(yourBalanceValueLabel)
        addSubview(separatorLineView)
        
        resultingBalanceTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(24)
        }
        
        balanceValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(resultingBalanceTitle)
            make.top.equalTo(resultingBalanceTitle.snp.bottom).offset(6)
        }
        
        comparisonLabel.snp.makeConstraints { make in
            make.leading.equalTo(balanceValueLabel)
            make.top.equalTo(balanceValueLabel.snp.bottom).offset(16)
        }
        
        yourBalanceTitle.snp.makeConstraints { make in
            make.leading.equalTo(comparisonLabel)
            make.top.equalTo(comparisonLabel.snp.bottom).offset(6)
        }
        
        yourBalanceValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(yourBalanceTitle.snp.trailing).offset(2)
            make.centerY.equalTo(yourBalanceTitle)
        }
        
        topTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(resultingBalanceTitle)
        }
        
        topPositionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(balanceValueLabel)
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
