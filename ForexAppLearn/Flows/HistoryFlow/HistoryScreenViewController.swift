import UIKit

final class HistoryScreenViewController: DefaultViewController {
    let service = NetEngine()
    let viewModel = HistoryScreenViewModel()
    
    private let headerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hex: "080B14", alpha: 0.94)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.interMedium(size: 18)
        label.text = R.string.localizable.tabBarHistoryTitle()
        return label
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
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHistory()
    }
    
    private func updateHistory() {
        service.fetchHistory { [weak self] result in
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

extension HistoryScreenViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sectionsData[section].deals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HistoryCell.identifier,
            for: indexPath
        ) as? HistoryCell else {
            return UICollectionViewCell()
        }
        let model = viewModel.sectionsData[indexPath.section].deals[indexPath.item]
        cell.configure(with: model)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sectionsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 57)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 71)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HistoryHeader.identifier, for: indexPath) as? HistoryHeader else {
                return UICollectionReusableView()
            }
            header.configure(with: viewModel.sectionsData[indexPath.section])
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}
