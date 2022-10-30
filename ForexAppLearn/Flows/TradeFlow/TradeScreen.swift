import WebKit
import UIKit

final class TradeScreenViewController: DefaultViewController {
    
    let viewModel = TradeScreenViewModel()
    let networkService = NetEngine()
    private let header: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "080B14", alpha: 0.94)
        return view
    }()
    
    private let balanceValueLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interMedium(size: 18)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "$10 000"
        return label
    }()
    
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let courseLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interMedium(size: 32)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "0.00000"
        return label
    }()
    
    private let changeRateAbsLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 16)
        label.text = "00000"
        return label
    }()
    
    private let changeRateRelativeLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 16)
        label.text = "00000%"
        label.backgroundColor = UIColor(hex: "00BD92", alpha: 0.3)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    let currencyPairSelectionButton: UIButton = {
        let button = UIButton(type: .system)
//        button.backgroundColor = .white.withAlphaComponent(0.06)
        let attrTitle = NSAttributedString(
            string: "EUR/USD",
            attributes: [
                .font: R.font.interRegular(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.setImage(R.image.chevronDown(), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .white
        button.layer.cornerRadius = 6
        return button
    }()
    
    let chartView = WKWebView()
    var currentSelectedPair: CurrencyPairs = .EURUSD
    
    private let timeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 11)
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .left
        label.text = R.string.localizable.time().uppercased()
        return label
    }()
    
    private let countTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 11)
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .left
        label.text = R.string.localizable.amount().uppercased()
        return label
    }()
    
    private lazy var timeTextField: UITextField = {
        let textField = InaccessibleTextField()
        textField.layer.cornerRadius = 4
        textField.backgroundColor = UIColor(hex: "090B11")
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor(hex: "BABCC3", alpha: 0.4).cgColor
        textField.text = "00:30"
        textField.delegate = self
        textField.textColor = .white
//        textField.isEnabled = false
        textField.addTarget(self, action: #selector(timeFieldDidTapped), for: .touchDown)
        return textField
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = InaccessibleTextField()
        textField.layer.cornerRadius = 4
        textField.backgroundColor = UIColor(hex: "090B11")
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor(hex: "BABCC3", alpha: 0.4).cgColor
        textField.text = "$0"
        textField.delegate = self
        textField.textColor = .white
        textField.addTarget(self, action: #selector(amountFieldDidTapped), for: .touchDown)
        return textField
    }()
    
    private let sellButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.backgroundColor = UIColor(hex: "E93F6C")
        button.setImage(R.image.arrowDown(), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .black
        let attrTitle = NSAttributedString(
            string: R.string.localizable.toSell(),
            attributes: [
                .font: R.font.interRegular(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.imageEdgeInsets.left = 50
        return button
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.backgroundColor = UIColor(hex: "00BD92")
        button.setImage(R.image.arrowUp(), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .black
        let attrTitle = NSAttributedString(
            string: R.string.localizable.toBuy(),
            attributes: [
                .font: R.font.interRegular(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.imageEdgeInsets.left = 50
        return button
    }()
    
    private lazy var intervalChangeButtons: [UIButton] = {
        TimeIntervals.allCases.enumerated().map { index, interval in
            let button = IntervalSelectionButton(type: .custom)
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrTitle = NSAttributedString(
                string: interval.buttonTitle,
                attributes: [
                    .font: R.font.interRegular(size: 13) ?? .systemFont(ofSize: 13),
                    .foregroundColor: UIColor.white,
                    .paragraphStyle: paragraphStyle
                ]
            )
            button.tintColor = .clear
            button.setAttributedTitle(attrTitle, for: .normal)
            button.setAttributedTitle(attrTitle, for: .selected)
            button.setTitleColor(.white, for: .selected)
            button.setImage(nil, for: .selected)
            if index == 0 {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        
            button.layer.cornerRadius = 4

//            button.layer.borderColor = UIColor.white.cgColor
            button.addTarget(self, action: #selector(timeIntervalChanged(sender:)), for: .touchUpInside)
            button.tag = index
            return button
        }
    }()
    
    
    lazy var buttonsStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private var tradeTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        setupPolling()
        setupActions()
        updateAmountField()
    }
    
    @objc private func timeFieldDidTapped() {
        guard tradeTimer == nil else { return }
        let vc = TimeSelectorViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: false)
    }
    
    @objc private func amountFieldDidTapped() {
        guard tradeTimer == nil else { return }
        let vc = AmountSelectorViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: false)
    }
    
    private func requestData() {
        networkService.requestAllCurrenciesCourses { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                self.viewModel.currenciesData = response.currencies
                DispatchQueue.main.async {
                    self.updateCurrencyData()
                }
            }
        }
        if let url = UserLocalSettings.user?.avatar {
            avatarImage.kf.setImage(with: url)
        } else {
            avatarImage.image = R.image.avatarPlaceholder()
        }
    }
    
    private func setupActions() {
        currencyPairSelectionButton.addTarget(self, action: #selector(showPairSelector), for: .touchUpInside)
        sellButton.addTarget(self, action: #selector(sellButtonTapped), for: .touchUpInside)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        avatarImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showHistory)))
    }
    
    private func setupPolling() {
        _ = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { [weak self] _ in
            self?.requestData()
        }).fire()
    }
    
    @objc private func showPairSelector() {
        guard let currentPairData = viewModel.getCurrencyDataForCurrentPair() else {
            return
        }
        let vc = PairsSelectorViewController(pairsData: viewModel.currenciesData, selectedPair: currentPairData )
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: false)
    }
    
    @objc private func showHistory() {
        let vc = HistoryScreenViewController()
        present(vc, animated: true)
    }
    
    private func updateCurrencyData() {
        guard let model = viewModel.getCurrencyDataForCurrentPair()
        else { return }
        courseLabel.text = String(format: "%.5f", model.price)
        var changeRateAbsString = String(format: "%.4f", model.change)
        var changeRateRelativeString = String(format: "%.2f", model.changeInPercent)
        if model.changeInPercent > 0 {
            changeRateAbsString = "+" + changeRateAbsString
            changeRateRelativeString = "+" + changeRateRelativeString + "%"
        } else {
            changeRateRelativeString = changeRateRelativeString + "%"
        }
        
        changeRateAbsLabel.text = changeRateAbsString
        changeRateRelativeLabel.text = changeRateRelativeString
        changeRateAbsLabel.textColor = model.changeInPercent > 0 ? UIColor(hex: "56BB4D") : UIColor(hex: "DE594C")
        changeRateRelativeLabel.textColor = model.changeInPercent > 0 ? UIColor(hex: "56BB4D") : UIColor(hex: "DE594C")
        currencyPairSelectionButton.setAttributedTitle(getAttributedTitleForSelector(for: viewModel.getCurrentlySelectedPairTitle()), for: .normal)
        balanceValueLabel.text = "$\(UserLocalSettings.user?.balance ?? 0)"
    }
    
    private func updateAmountField() {
        let amount = viewModel.currentBid
        amountTextField.text = "$\(amount)"
    }
    
    override func setupAppearance() {
        view.backgroundColor = UIColor(hex: "010811")
        currencyPairSelectionButton.setAttributedTitle(getAttributedTitleForSelector(for: viewModel.getCurrentlySelectedPairTitle()), for: .normal)
        updateChart()
    }
    
    private func updateChart() {
        chartView.loadHTMLString(viewModel.getHtmlForWebView(), baseURL:  nil)
        chartView.backgroundColor = UIColor(hex: "010811")
        chartView.scrollView.isScrollEnabled = false
    }
    
    private func getAttributedTitleForSelector(for string: String) -> NSAttributedString {
        let attrTitle = NSAttributedString(
            string: string,
            attributes: [
                .font: R.font.interRegular(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
        )
        return attrTitle
    }
    
    private func updateTimeField() {
        let seconds = viewModel.chosenTimerSeconds
        
        let minutes = seconds / 60
        let minutesString = "0\(minutes)"
        let realSeconds = seconds - minutes * 60
        var secondsString = ""
        if realSeconds < 10 {
            secondsString = "0\(realSeconds)"
        } else {
            secondsString = "\(realSeconds)"
        }
        print("\(minutesString):\(secondsString)")
        timeTextField.text = "\(minutesString):\(secondsString)"
    }
    
    @objc private func timeIntervalChanged(sender: UIButton) {
        intervalChangeButtons.enumerated().forEach { index, button in
            if sender == button {
                sender.isSelected = true
                viewModel.selectedInterval = TimeIntervals(rawValue: index) ?? .oneMin
                updateChart()
                print(viewModel.selectedInterval)
            } else {
                button.isSelected = false
            }
        }
    }
    
    override func addSubviews() {
        view.addSubview(header)
        header.addSubview(balanceValueLabel)
        header.addSubview(currencyPairSelectionButton)
        header.addSubview(avatarImage)
        view.addSubview(courseLabel)
        view.addSubview(changeRateAbsLabel)
        view.addSubview(changeRateRelativeLabel)
        view.addSubview(chartView)
        view.addSubview(buttonsStackView)
        view.addSubview(timeTitleLabel)
        view.addSubview(countTitleLabel)
        view.addSubview(timeTextField)
        view.addSubview(amountTextField)
        view.addSubview(sellButton)
        view.addSubview(buyButton)
        intervalChangeButtons.forEach { button in
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    @objc private func sellButtonTapped() {
        guard viewModel.chosenTimerSeconds > 0 else { return }
        sellButton.isEnabled = false
        sellButton.backgroundColor = UIColor(hex: "85233D")
        buyButton.isEnabled = false
        buyButton.backgroundColor = UIColor(hex: "006F55")
        currencyPairSelectionButton.isEnabled = false
        guard let currentCurrencyData = viewModel.getCurrencyDataForCurrentPair() else { return }
        viewModel.startingPrice = currentCurrencyData.price
        tradeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.viewModel.chosenTimerSeconds -= 1
            self.updateTimeField()
            if self.viewModel.chosenTimerSeconds == 0 {
                self.networkService.requestAllCurrenciesCourses { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let response):
                        self.viewModel.currenciesData = response.currencies
                        DispatchQueue.main.async {
                            self.updateCurrencyData()
                        }
                        guard let currentPrice = self.viewModel.getCurrencyDataForCurrentPair()?.price else { return }
                        self.viewModel.endPrice = currentPrice
                        let tradeModel = self.viewModel.makeTradeModel(for: .sell)
                        self.networkService.makeTrade(with: tradeModel) { result  in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(let response):
                                UserLocalSettings.user = response.user
                                DispatchQueue.main.async {
                                    self.updateCurrencyData()
                                    self.sellButton.isEnabled = true
                                    self.sellButton.backgroundColor = UIColor(hex: "E93F6C")
                                    self.buyButton.isEnabled = true
                                    self.currencyPairSelectionButton.isEnabled = true
                                    self.buyButton.backgroundColor = UIColor(hex: "00BD92")
                                }
                            }
                        }
                    }
                }
                timer.invalidate()
                self.tradeTimer = nil
                return
            }
            self.updateAmountField()
        }
    }
    
    @objc private func buyButtonTapped() {
        guard viewModel.chosenTimerSeconds > 0 else { return }
        sellButton.isEnabled = false
        sellButton.backgroundColor = UIColor(hex: "85233D")
        buyButton.isEnabled = false
        buyButton.backgroundColor = UIColor(hex: "006F55")
        currencyPairSelectionButton.isEnabled = false
        guard let currentCurrencyData = viewModel.getCurrencyDataForCurrentPair() else { return }
        viewModel.startingPrice = currentCurrencyData.price
        tradeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.viewModel.chosenTimerSeconds -= 1
            self.updateTimeField()
            if self.viewModel.chosenTimerSeconds == 0 {
                self.networkService.requestAllCurrenciesCourses { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let response):
                        self.viewModel.currenciesData = response.currencies
                        DispatchQueue.main.async {
                            self.updateCurrencyData()
                        }
                        guard let currentPrice = self.viewModel.getCurrencyDataForCurrentPair()?.price else { return }
                        self.viewModel.endPrice = currentPrice
                        let tradeModel = self.viewModel.makeTradeModel(for: .buy)
                        self.networkService.makeTrade(with: tradeModel) { result  in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(let response):
                                UserLocalSettings.user = response.user
                                DispatchQueue.main.async {
                                    self.updateCurrencyData()
                                    self.sellButton.isEnabled = true
                                    self.sellButton.backgroundColor = UIColor(hex: "E93F6C")
                                    self.buyButton.isEnabled = true
                                    self.currencyPairSelectionButton.isEnabled = true
                                    self.buyButton.backgroundColor = UIColor(hex: "00BD92")
                                }
                            }
                        }
                    }
                }
                timer.invalidate()
                self.tradeTimer = nil
                return
            }
            self.updateAmountField()
        }
    }
    
    override func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(94.fitH)
        }
        
        balanceValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(currencyPairSelectionButton)
            make.leading.equalTo(currencyPairSelectionButton.snp.trailing).offset(16)
        }
        
        avatarImage.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(24)
        }
        courseLabel.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(24.fitH)
            make.leading.equalToSuperview().offset(24.fitW)
        }
        
        changeRateAbsLabel.snp.makeConstraints { make in
            make.top.equalTo(courseLabel.snp.bottom).offset(2)
            make.leading.equalTo(courseLabel)
           
        }
        
        changeRateRelativeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(courseLabel)
            make.leading.equalTo(courseLabel.snp.trailing).offset(16)
            make.width.equalTo(78)
            make.height.equalTo(35)
        }
        
        currencyPairSelectionButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(123)
            make.bottom.equalToSuperview()
        }
        
        chartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(changeRateAbsLabel.snp.bottom).offset(16.fitH)
            make.height.equalTo(342.fitH)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24.fitW)
            make.height.equalTo(36)
            make.top.equalTo(chartView.snp.bottom).offset(16)
        }
        
        timeTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24.fitW)
            make.top.equalTo(buttonsStackView.snp.bottom).offset(21)
        }
        
        timeTextField.snp.makeConstraints { make in
            make.leading.equalTo(timeTitleLabel)
            make.height.equalTo(42)
            make.width.equalTo((view.bounds.width - (24.fitW * 2) - 8) / 2)
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(20.fitH)
        }
        
        countTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeTextField.snp.trailing).offset(8)
            make.top.equalTo(timeTitleLabel)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.leading.equalTo(countTitleLabel)
            make.centerY.equalTo(timeTextField)
            make.height.equalTo(42)
            make.width.equalTo((view.bounds.width - (24.fitW * 2) - 8) / 2)
        }
        
        sellButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.trailing.equalTo(timeTextField)
            make.top.equalTo(timeTextField.snp.bottom).offset(30.fitH)
        }
        
        buyButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.trailing.equalTo(amountTextField)
            make.top.equalTo(amountTextField.snp.bottom).offset(30.fitH)
        }
    }
}

extension TradeScreenViewController: UITextFieldDelegate {
    
}

extension TradeScreenViewController: PairsSelectorViewControllerDelegate  {
    func pairDidSelected(pair: CurrencyNetModel) {
        viewModel.selectedPair = pair.pair
        updateChart()
        updateCurrencyData()
    }
}

extension TradeScreenViewController: TimeSelectorDelegate {
    func didSelectTime(ofTotal seconds: Int) {
        print(seconds)
        viewModel.chosenTimerSeconds = seconds
        updateTimeField()
    }
}

extension TradeScreenViewController: AmountSelectorDelegate {
    func didSelectAmount(ofTotal amount: Int) {
        viewModel.currentBid = amount
        updateAmountField()
    }
}
