//
//  IntervalSelectionButton.swift
//  Quotex
//
//  Created by Yaşar Ergin on 14.10.2022.
//

import UIKit

final class IntervalSelectionButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 1
                layer.borderColor = UIColor(hex: "FF9933").cgColor
            } else {
                layer.borderWidth = 0.5
                layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = 4
        layer.cornerCurve = .continuous
        layer.allowsEdgeAntialiasing = true
    }
}
