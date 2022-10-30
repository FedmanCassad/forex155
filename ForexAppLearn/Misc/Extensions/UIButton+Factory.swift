import UIKit

extension UIButton {
    static func makeOnboardingButton(with title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(hex: "F1CB2F")
        let attrTitle = NSAttributedString(
            string: title.uppercased(),
            attributes: [
                .font: R.font.interMedium(size: 14) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ]
        )
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.setAttributedTitle(attrTitle, for: .normal)
        return button
    }
    
    static func makeOnboardingAnswerButton(with title: String) -> UIButton {
        let button = OnboardAnswerButton(type: .system)
        button.backgroundColor = .white.withAlphaComponent(0.12)
        let attrTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: R.font.interRegular(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.white.withAlphaComponent(0.9)
            ]
        )
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.setAttributedTitle(attrTitle, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleEdgeInsets.left = 16
        return button
    }
    
    func setTitleWithAnswerAttributes(title: String) {
        let attrTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: R.font.interRegular(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.white.withAlphaComponent(0.9)
            ]
        )
        setAttributedTitle(attrTitle, for: .normal)
    }
}
