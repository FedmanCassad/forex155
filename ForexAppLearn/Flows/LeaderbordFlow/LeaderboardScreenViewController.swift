//
//  LeaderboardScreen.swift
//  Quotex
//

import UIKit

final class LeaderboardScreenViewController: DefaultViewController {
    let service = NetEngine()
    let viewModel = LeadersViewModel()
    
    private let headerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hex: "080B14", alpha: 0.94)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.interMedium(size: 18)
        label.text = R.string.localizable.leadersTopTraders()
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(LeaderBoardCell.self, forCellWithReuseIdentifier: LeaderBoardCell
            .identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRating()
    }
    
    private func updateRating() {
        service.fetchRating { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                self?.viewModel.ratingData = response.rating
                print(response.rating)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    override func addSubviews() {
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(94.fitH)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24.fitW)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension LeaderboardScreenViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.ratingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LeaderBoardCell.identifier,
            for: indexPath
        ) as? LeaderBoardCell else {
            return UICollectionViewCell()
        }
        let model = viewModel.ratingData[indexPath.item]
        cell.configure(with: model, at: indexPath)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 92)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ratingModel = viewModel.ratingData[indexPath.item]
        let leaderDetailsVm = LeaderDetailsViewModel(with: ratingModel, position: indexPath.item + 1)
        let vc = LeaderDetailsController(viewModel: leaderDetailsVm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
