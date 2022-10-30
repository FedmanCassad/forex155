//
//  CountryCell.swift
//  Quotex
//

import UIKit

class CountryCell: UICollectionViewCell {
    
    static let identifier = String(describing: CountryCell.self)
    
    private var countryTitleLabel: UILabel = {
       let label = UILabel()
        label.font = R.font.interRegular(size: 16)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .left
        return label
    }()
    
    private var selectionImage: UIImageView = UIImageView()
    
    private let separatorLineView: UIView = {
         let view = UIView()
         view.backgroundColor = UIColor(hex: "BABCC3", alpha: 0.4)
         return view
     }()

    override var isSelected: Bool {
        didSet {
            if isSelected {
                countryTitleLabel.textColor = UIColor(hex: "FF9933")
                selectionImage.image = R.image.selectedCountryCell()
            } else {
                countryTitleLabel.textColor = .white
                selectionImage.image = R.image.unselectedCountryCell()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: CountryModel) {
        countryTitleLabel.text = model.title
        selectionImage.image = isSelected ? R.image.selectedCountryCell() : R.image.unselectedCountryCell()
    }
    
    private func setupSubviews() {
        contentView.addSubview(countryTitleLabel)
        contentView.addSubview(selectionImage)
        contentView.addSubview(separatorLineView)
        
        countryTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        selectionImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
