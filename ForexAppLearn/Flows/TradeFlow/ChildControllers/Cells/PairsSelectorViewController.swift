//
//  PairsSelectorViewController.swift
//  Quotex
//
//  Created by Yaşar Ergin on 14.10.2022.
//

import UIKit

protocol PairsSelectorViewControllerDelegate: AnyObject {
    func pairDidSelected(pair: CurrencyNetModel)
}

final class PairsSelectorViewController: DefaultViewController {
    weak var delegate: PairsSelectorViewControllerDelegate?
    let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    let shapeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor(hex: "14161C")
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = .white.withAlphaComponent(0.5)
        return view
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.interMedium(size: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = R.string.localizable.searchPlaceholder()
        bar.searchBarStyle = .minimal
        bar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        bar.searchTextField.textColor = .white
        bar.delegate = self
        return bar
    }()
    
    private let separatorLineOne: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "BABCC3", alpha: 0.4)
        return view
    }()
    
    private let separatorLineTwo: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "BABCC3", alpha: 0.4)
        return view
    }()
    
    private let footerSubview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "1D222D")
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell
            .identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    var selectedPair: CurrencyNetModel
    
    let selectionButton = UIButton.makeOnboardingButton(with: R.string.localizable.buttonSelectTitle())
    
    var searchPhrase: String = ""
    
    var allPairs: [CurrencyNetModel]
    
    init(pairsData: [CurrencyNetModel], selectedPair: CurrencyNetModel) {
        self.allPairs = pairsData
        self.selectedPair = selectedPair
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSelector()
        guard let index = allPairs.firstIndex(where: { model in
            model.pair == selectedPair.pair
        }) else {
            return
        }
        
        collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .top)
    }
    
    private func getFilteredPairs() -> [CurrencyNetModel] {
        guard !searchPhrase.isEmpty else {
            return allPairs
        }
        return allPairs.filter { $0.pair.rawValue.lowercased().contains(searchPhrase.lowercased()) }
    }
    
    private func getNumberOfItems() -> Int {
        getFilteredPairs().count
    }
    
    override func addSubviews() {
        view.addSubview(blurView)
        blurView.contentView.addSubview(shapeView)
        shapeView.addSubview(separatorView)
        shapeView.addSubview(countryLabel)
        shapeView.addSubview(searchBar)
        shapeView.addSubview(separatorLineOne)
        shapeView.addSubview(separatorLineTwo)
        shapeView.addSubview(collectionView)
        shapeView.addSubview(footerSubview)
        footerSubview.addSubview(selectionButton)
    }
    
    override func setupAppearance() {
        view.backgroundColor = .clear
    }
    
    private func setupActions() {
        selectionButton.addTarget(self, action: #selector(countrySelected), for: .touchUpInside)
    }
    
    override func setupConstraints() {
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        shapeView.snp.makeConstraints { make in
            make.height.equalTo(580.fitH)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(blurView.contentView.snp.bottom)
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.width.equalTo(48)
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
        }
        
        countryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(32.fitH)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(36)
            make.top.equalTo(countryLabel.snp.bottom).offset(12)
        }
        
        separatorLineOne.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16.fitH)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(separatorLineOne.snp.bottom)
            make.bottom.equalToSuperview().inset(148)
        }
        
        separatorLineTwo.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        footerSubview.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(147)
        }
        
        selectionButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(12)
        }
    }
    
    private func showSelector() {
        shapeView.snp.remakeConstraints { make in
            make.height.equalTo(580.fitH)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideController() {
        shapeView.snp.remakeConstraints { make in
            make.height.equalTo(580.fitH)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(blurView.contentView.snp.bottom)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.blurView.alpha = 0
        } completion: { _ in
            self.delegate?.pairDidSelected(pair: self.selectedPair)
            self.dismiss(animated: false)
        }
    }
    
    @objc private func countrySelected() {
        hideController()
    }
}


extension PairsSelectorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !getFilteredPairs().isEmpty else { return }
        let model = getFilteredPairs()[indexPath.item]
        selectedPair = model
    }
}

extension PairsSelectorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: CurrencyCell.identifier, for: indexPath) as? CurrencyCell else {
            return UICollectionViewCell()
        }
        let model = getFilteredPairs()[indexPath.item]
        cell.configure(with: model)
        return cell
    }
}

extension PairsSelectorViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPhrase = searchText
        collectionView.reloadSections(IndexSet(integer: 0))
    }
}

