//
//  LoadingScreen.swift
//  Quotex

import UIKit

final class LoadingScreen: DefaultViewController {
    var finishHandler: (() -> Void)?
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .white.withAlphaComponent(0.08)
        progressView.tintColor = UIColor(hex: "FF9933")
        progressView.setProgress(0, animated: false)
        progressView.layer.cornerRadius = 7
        progressView.clipsToBounds = true
        return progressView
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interRegular(size: 11)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "0 %"
        return label
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.splashImage()
        return imageView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func setupAppearance() {
        view.backgroundColor = UIColor(hex: "242A44")
    }
    
    override func addSubviews() {
        view.addSubview(backgroundImage)
        view.addSubview(progressView)
        view.addSubview(progressLabel)
    }
    
    override func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(120)
            make.leading.trailing.equalToSuperview().inset(90.fitW)
            make.height.equalTo(20)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.leading.equalTo(progressView.snp.leading)
            make.centerY.equalTo(progressView)
        }
    }
    
    private func updatePercentageLabelPosition() {
        progressLabel.snp.remakeConstraints { make in
            make.leading.equalTo(progressView.snp.leading).offset(
                CGFloat(progressView.progress) * progressView.bounds.width -  (progressLabel.bounds.width * 2 * CGFloat(progressView.progress)))
            make.centerY.equalTo(progressView)
        }
    }
    
    private func runLoading() {
        var counter = 0
        _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            counter += 1
            guard counter <= 100 else {
                timer.invalidate()
                self?.finishHandler?()
                return
            }
            self?.progressLabel.text = "\(counter) %"
            self?.progressView.setProgress(Float(counter) / 100, animated: true)
            self?.updatePercentageLabelPosition()
        }
    }
}
