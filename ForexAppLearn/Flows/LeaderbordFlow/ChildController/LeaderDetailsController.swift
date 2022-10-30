//
//  LeaderDeatailsController.swift
//  Quotex
//

import UIKit

final class LeaderDetailsController: DefaultViewController {
    let viewModel: LeaderDetailsViewModel
    let service = NetEngine()
    
    private let headerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hex: "080B14", alpha: 0.94)
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let attrTitle = NSAttributedString(
            string: R.string.localizable.buttonBack(),
            attributes: [
                .font: R.font.interRegular(size: 12) ?? .systemFont(ofSize: 12),
                .foregroundColor: UIColor(hex: "3789E2")
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interMedium(size: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let userAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(HistoryCell.self, forCellWithReuseIdentifier: HistoryCell
            .identifier)
        collection.register(
            HistoryHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HistoryHeader.identifier
        )
        collection.register(
            LeaderDetailsHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: LeaderDetailsHeader.identifier
        )
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    init(viewModel: LeaderDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupHeader()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        service.fetchHistory(forSpecific: viewModel.userRatingModel.userID) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                self?.viewModel.initialHistoryData = response.history
                self?.viewModel.makeSectionsData()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    private func setupHeader() {
        usernameLabel.text = viewModel.userRatingModel.userName
        userAvatar.kf.setImage(with: URL(string: viewModel.userRatingModel.avatar))
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(popBack), for: .touchUpInside)
    }
    
    @objc private func popBack() {
        navigationController?.popViewController(animated: true)
    }
    
    override func addSubviews() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(usernameLabel)
        headerView.addSubview(userAvatar)
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(94.fitH)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(12)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
        
        userAvatar.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(usernameLabel)
            make.trailing.equalToSuperview().inset(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}


extension LeaderDetailsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            print("number in section \(section - 1) is \(viewModel.sectionsData[section - 1].deals.count)")
            return viewModel.sectionsData[section - 1].deals.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section > 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HistoryCell.identifier,
                for: indexPath
            ) as? HistoryCell else {
                return UICollectionViewCell()
            }
            let model = viewModel.sectionsData[indexPath.section - 1].deals[indexPath.item]
            cell.configure(with: model)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1 + viewModel.sectionsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.width, height: 168)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 71)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 71)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section > 0 {
                guard let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HistoryHeader.identifier, for: indexPath) as? HistoryHeader else {
                    return UICollectionReusableView()
                }
                header.configure(with: viewModel.sectionsData[indexPath.section - 1])
                return header
            } else {
                guard let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LeaderDetailsHeader.identifier, for: indexPath) as? LeaderDetailsHeader else {
                    return UICollectionReusableView()
                }
                header.configure(with: viewModel.userRatingModel, position: viewModel.position)
                return header
            }
        } else {
            return UICollectionReusableView()
        }
    }
}
