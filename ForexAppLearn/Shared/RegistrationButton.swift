
import UIKit

final class RegistrationButton: UIButton {
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.chevronDown()
        imageView.contentMode = .center
        imageView.tintColor = .white
        return imageView
    }()
    
    private let advancedTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 16)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMyTitle(title: String?) {
        advancedTitleLabel.text = title
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        advancedTitleLabel.text = title
    }
    
    private func setupSubviews() {
        titleLabel?.removeFromSuperview()
        imageView?.removeFromSuperview()
        addSubview(advancedTitleLabel)
        addSubview(chevronImageView)
        
        advancedTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.height.width.equalTo(24)
        }
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        drawShape()
    }
    
    private func drawShape() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 4)
        guard let layer = layer as? CAShapeLayer else { return }
        layer.path = path.cgPath
        layer.fillColor = UIColor(hex: "090B11").cgColor
        layer.lineWidth = 0.5
        layer.strokeColor = UIColor(hex: "BABCC3", alpha: 0.4).cgColor
    }
}
