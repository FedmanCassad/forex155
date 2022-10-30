import StoreKit
import SnapKit
import UIKit

class OnboardController: DefaultViewController {
    var selectedIndex: Int = 0
    let viewModel = OnboardingViewModel()
    var nextStepHandler: (() -> Void)?
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.onboardingBackground()
        return imageView
    }()
    
    private let questionTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = R.font.interMedium(size: 24)
        return label
    }()
    
    private let firstOptionButton = UIButton.makeOnboardingAnswerButton(with: "")
    private let secondOptionButton = UIButton.makeOnboardingAnswerButton(with: "")
    private let nextButton = UIButton.makeOnboardingButton(with: R.string.localizable.buttonNextTitle())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    override func setupAppearance() {
        view.backgroundColor = UIColor(hex: "010811")
        firstOptionButton.alpha = 0
        secondOptionButton.alpha = 0
        questionTitle.alpha = 0
        backgroundImage.image = R.image.onboardingBackground()
    }
    
    override func addSubviews() {
        view.addSubview(backgroundImage)
        view.addSubview(nextButton)
        view.addSubview(questionTitle)
        view.addSubview(firstOptionButton)
        view.addSubview(secondOptionButton)
    }
    
    private func setupActions() {
        firstOptionButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        secondOptionButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
    }
    
    @objc private func nextStep() {
        selectedIndex += 1
        updateUI()
    }
    
    @objc private func nextController() {
        nextStepHandler?()
    }
    
    private func updateUI() {
        if (1...3).contains(selectedIndex) {
            let model = viewModel.getModel(at: selectedIndex - 1)
            let imageTransition = CATransition()
            imageTransition.duration = 0.3
            imageTransition.type = .fade
            let textTransition1 = CATransition()
            textTransition1.duration = 0.3
            textTransition1.type = .fade
            let textTransition2 = CATransition()
            textTransition2.duration = 0.3
            textTransition2.type = .fade
            let textTransition3 = CATransition()
            textTransition3.duration = 0.3
            textTransition3.type = .fade
            backgroundImage.image = R.image.onboardingBackgroundForQuiz()
            backgroundImage.layer.add(imageTransition, forKey: nil)
            questionTitle.text = model.question
            firstOptionButton.setTitleWithAnswerAttributes(title: model.firstOption)
            secondOptionButton.setTitleWithAnswerAttributes(title: model.secondOption)
            questionTitle.layer.add(textTransition1, forKey: nil)
            firstOptionButton.layer.add(textTransition2, forKey: nil)
            secondOptionButton.layer.add(textTransition3, forKey: nil)
            UIView.animate(withDuration: 0.3) {
                self.nextButton.alpha = 0
                self.questionTitle.alpha = 1
                self.firstOptionButton.alpha = 1
                self.secondOptionButton.alpha = 1
            }
        } else {
            nextStepHandler?()
        }
    }
    
    override func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        questionTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(202)
        }
        
        firstOptionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(55)
            make.top.equalTo(questionTitle.snp.bottom).offset(24)
        }
        
        secondOptionButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(55)
            make.top.equalTo(firstOptionButton.snp.bottom).offset(12)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(80.fitH)
            make.height.equalTo(56)
        }
    }
}
