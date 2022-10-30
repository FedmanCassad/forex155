import UIKit

final class OnboardAnswerButton: UIButton {
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.3) {
                    self.backgroundColor = UIColor(hex: "F1CB2F")
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.backgroundColor = .white.withAlphaComponent(0.12)
                }
            }
        }
    }
}
