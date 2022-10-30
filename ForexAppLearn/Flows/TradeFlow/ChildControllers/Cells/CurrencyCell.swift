//
//  CurrencyCell.swift
//  Quotex

import UIKit

class CurrencyCell: UICollectionViewCell {
    
    static let identifier = String(describing: CurrencyCell.self)
    
    private var currencyTitleLabel: UILabel = {
       let label = UILabel()
        label.font = R.font.interRegular(size: 16)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .left
        return label
    }()
    
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 16)
        return label
    }()
    
    private let changeRateRelativeLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 16)
        return label
    }()
    
    private var selectionImage: UIImageView = UIImageView()

    override var isSelected: Bool {
        didSet {
            if isSelected {
                currencyTitleLabel.textColor = UIColor(hex: "FF9933")
                selectionImage.image = R.image.selectedCountryCell()
            } else {
                currencyTitleLabel.textColor = .white.withAlphaComponent(0.7)
                selectionImage.image = R.image.unselectedCountryCell()
            }
        }
    }
    
   private let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "BABCC3", alpha: 0.4)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: CurrencyNetModel) {
        currencyTitleLabel.text = model.pair.buttonTitle
        selectionImage.image = isSelected ? R.image.selectedCountryCell() : R.image.unselectedCountryCell()
        let priceString = String(format: "%.5f", model.price)
        priceLabel.text = priceString
        priceLabel.textColor = model.changeInPercent > 0  ? UIColor(hex: "56BB4D") : UIColor(hex: "DE594C")
        var changeRateString = String(format: "%.2f", model.changeInPercent)
        
        if model.changeInPercent > 0  {
            changeRateString = "+" + changeRateString + "%"
        } else {
            changeRateString = changeRateString + "%"
        }
        changeRateRelativeLabel.text = changeRateString
        changeRateRelativeLabel.textColor = model.changeInPercent > 0  ? UIColor(hex: "56BB4D") : UIColor(hex: "DE594C")
    }
    
    private func setupSubviews() {
        contentView.addSubview(currencyTitleLabel)
        contentView.addSubview(selectionImage)
        contentView.addSubview(priceLabel)
        contentView.addSubview(changeRateRelativeLabel)
        contentView.addSubview(separatorLineView)
        
        currencyTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        selectionImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(currencyTitleLabel.snp.trailing).offset(85.fitW)
            make.centerY.equalTo(currencyTitleLabel)
        }
        
        changeRateRelativeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(selectionImage.snp.leading).inset(-20)
            make.centerY.equalTo(currencyTitleLabel)
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

