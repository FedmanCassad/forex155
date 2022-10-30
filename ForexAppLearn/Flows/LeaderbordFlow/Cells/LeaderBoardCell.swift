//
//  CountryCell.swift
//  Quotex
//

import Kingfisher
import UIKit

class LeaderBoardCell: UICollectionViewCell {
    
    static let identifier = String(describing: LeaderBoardCell.self)
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var indexLabel: UILabel = {
       let label = UILabel()
        label.font = R.font.interMedium(size: 18)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interMedium(size: 16)
        label.textColor = .white
        label.text = R.string.localizable.closed() + ":"
        return label
    }()
    
    private let balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 13)
        label.textColor = .white.withAlphaComponent(0.7)
        label.text = R.string.localizable.balance()
        return label
    }()
    
    private let balanceValueLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 13)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .left
        return label
    }()
    
    private let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "E9E8E8")
        return view
    }()
    
    private let chevronImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .white
        imageView.contentMode = .center
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Rating, at indexPath: IndexPath) {
        indexLabel.text = String(indexPath.item + 1)
        avatarImageView.kf.setImage(with: URL(string: model.avatar))
        userNameLabel.text = model.userName
        balanceValueLabel.text = "\(model.rate)"
    }
    
    private func setupSubviews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(indexLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(balanceTitleLabel)
        contentView.addSubview(balanceValueLabel)
        contentView.addSubview(chevronImage)
        contentView.addSubview(separatorLineView)
        
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(38)
        }
        
        indexLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27.5)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(18)
        }
        
        balanceTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(userNameLabel)
            make.top.equalTo(userNameLabel.snp.bottom).offset(2)
        }
        
        balanceValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(balanceTitleLabel)
            make.leading.equalTo(balanceTitleLabel.snp.trailing).offset(2)
        }
        
        chevronImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
