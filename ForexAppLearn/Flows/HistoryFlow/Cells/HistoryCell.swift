//
//  CountryCell.swift
//  Quotex
//

import UIKit

class HistoryCell: UICollectionViewCell {
    
    static let identifier = String(describing: HistoryCell.self)
    
    private let trendImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var pairLabel: UILabel = {
       let label = UILabel()
        label.font = R.font.interRegular(size: 16)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let closedLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 13)
        label.textColor = .white.withAlphaComponent(0.7)
        label.text = R.string.localizable.closed() + ":"
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 13)
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 16)
        return label
    }()
    
    private let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "E9E8E8")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: History) {
        let trendImage = model.dealMode == 1 ? R.image.greenArrowUp() : R.image.redArrowDown()
        trendImageView.image = trendImage
        pairLabel.text = model.currency.buttonTitle
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM:ss"
        let dateString = formatter.string(from: model.createdAt)
        timestampLabel.text = dateString
        var valueString = ""
        if model.dealValue > 0 {
            valueString = "+$\(model.dealValue)"
            resultLabel.textColor = UIColor(hex: "56BB4D")
        } else {
            valueString = "-$" + "\(model.dealValue)".replacingOccurrences(of: "-", with: "")
            resultLabel.textColor = UIColor(hex: "DE594C")
        }
        resultLabel.text = valueString
    }
    
    private func setupSubviews() {
        contentView.addSubview(trendImageView)
        contentView.addSubview(pairLabel)
        contentView.addSubview(closedLabel)
        contentView.addSubview(timestampLabel)
        contentView.addSubview(resultLabel)
        contentView.addSubview(separatorLineView)
        
        trendImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        pairLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(trendImageView.snp.trailing).offset(12)
        }
        
        closedLabel.snp.makeConstraints { make in
            make.leading.equalTo(pairLabel)
            make.top.equalTo(pairLabel.snp.bottom).offset(4)
        }
        
        timestampLabel.snp.makeConstraints { make in
            make.centerY.equalTo(closedLabel)
            make.leading.equalTo(closedLabel.snp.trailing).offset(2)
        }
        
        resultLabel.snp.makeConstraints { make in
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
