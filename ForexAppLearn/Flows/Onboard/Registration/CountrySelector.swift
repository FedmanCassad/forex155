//
//  CountrySelector.swift
//  Quotex
//
//  Created by Yaşar Ergin on 13.10.2022.
//

import UIKit

protocol CountrySelectorDelegate: AnyObject {
    func countryDidSelected(country: CountryModel)
}

final class CountrySelectorViewController: DefaultViewController {
    weak var delegate: CountrySelectorDelegate?
    let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemThickMaterialDark)
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
        collection.register(CountryCell.self, forCellWithReuseIdentifier: CountryCell
            .identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    var selectedCountry: CountryModel?
    
    let selectionButton = UIButton.makeOnboardingButton(with: R.string.localizable.buttonSelectTitle())
    
    var searchPhrase: String = ""
    
    var allCountries = CountryModel.allCountries
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSelector()
        guard let index = allCountries.firstIndex(where: { model in
            if Locale.current.languageCode == "ru" {
                return model.langCode == "ru"
            } else {
                return model.langCode == "en"
            }
        }) else {
            return
        }
        
        collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .top)
    }
    
    private func getFilteredCountries() -> [CountryModel] {
        guard !searchPhrase.isEmpty else {
            return allCountries
        }
        return allCountries.filter { $0.title.lowercased().contains(searchPhrase.lowercased()) }
    }
    
    private func getNumberOfItems() -> Int {
        getFilteredCountries().count
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
            guard let selectedCountry = self.selectedCountry else { return }
            self.delegate?.countryDidSelected(country: selectedCountry)
            self.dismiss(animated: false)
        }
    }
    
    @objc private func countrySelected() {
        hideController()
    }
}


extension CountrySelectorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !getFilteredCountries().isEmpty else { return }
        let model = getFilteredCountries()[indexPath.item]
        selectedCountry = model
    }
}

extension CountrySelectorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: CountryCell.identifier, for: indexPath) as? CountryCell else {
            return UICollectionViewCell()
        }
        let model = getFilteredCountries()[indexPath.item]
        cell.configure(with: model)
        return cell
    }
}

extension CountrySelectorViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPhrase = searchText
        collectionView.reloadSections(IndexSet(integer: 0))
    }
}
