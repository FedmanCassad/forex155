//
//  SettingsButton.swift
//  Quotex
//
//  Created by Yaşar Ergin on 15.10.2022.
//

import UIKit

final class SettingsButton: UIButton {
        
    private let chevron: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .center
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        contentMode = .left
        tintColor = .white
        contentHorizontalAlignment = .left
        titleEdgeInsets.left = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(chevron)
        imageView?.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        chevron.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
