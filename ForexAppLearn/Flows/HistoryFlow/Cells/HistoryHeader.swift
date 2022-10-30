//
//  HeaderView.swift
//  Quotex
//
//  Created by Yaşar Ergin on 14.10.2022.
//

import UIKit

final class HistoryHeader: UICollectionReusableView {
    static let identifier = String(describing: HistoryHeader.self)
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 14)
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: HistorySection) {
        timestampLabel.text = model.title
    }
    
    private func setupSubviews() {
        addSubview(timestampLabel)
        
        timestampLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
