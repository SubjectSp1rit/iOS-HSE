//
//  WishCalendarView.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 02.12.2024.
//

import Foundation
import UIKit

final class WishCalendarView: UIView {
    // MARK: - Constants
    private enum Constants {
        // addEventButton
        static let addEventButtonImageName: String = "plus"
        
        // noWishesImage
        static let noWishesImageName: String = "noWishes"
        static let noWishesImageLeadingIndent: CGFloat = 50
        
        // collectionView
        static let layoutMinimumInteritemSpacing: CGFloat = 0
        static let layoutMinimumLineSpacing: CGFloat = 0
        static let contentInset: CGFloat = 10
    }
    
    // MARK: - UI Components
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    let addEventButton: UIBarButtonItem = UIBarButtonItem()
    let noWishesImage: UIImageView = UIImageView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configureBackground(with bgColor: UIColor) {
        backgroundColor = bgColor
    }
    
    func configureCollectionViewDelegate(_ delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
    
    func configureAddEventButton(in navigationItem: UINavigationItem, _ target: WishCalendarViewController) {
        addEventButton.image = UIImage(systemName: Constants.addEventButtonImageName)
        addEventButton.style = .plain
        addEventButton.target = target
        navigationItem.rightBarButtonItem = addEventButton
    }
    
    func configureBar(in navigationBar: UINavigationBar?) {
        navigationBar?.isTranslucent = true
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
    }
    
    func configureNoWishesImage(mode: String) {
        if mode == "delete" {
            noWishesImage.removeFromSuperview()
            return
        }
        addSubview(noWishesImage)
        
        noWishesImage.contentMode = .scaleAspectFit
        noWishesImage.image = UIImage(named: Constants.noWishesImageName)
        noWishesImage.pinCenterX(to: centerXAnchor)
        noWishesImage.pinCenterY(to: centerYAnchor)
        noWishesImage.pinLeft(to: leadingAnchor, Constants.noWishesImageLeadingIndent, .grOE) // Гарантируем что отступ от левого края >= indent
    }
    
    func reloadTable() {
        collectionView.reloadData()
    }
    
    // MARK: - Private methods
    private func configureUI() {
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: Constants.contentInset, left: Constants.contentInset, bottom: Constants.contentInset, right: Constants.contentInset)
        collectionView.clipsToBounds = true
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = Constants.layoutMinimumInteritemSpacing
            layout.minimumLineSpacing = Constants.layoutMinimumLineSpacing
            
            layout.invalidateLayout()
        }
        
        collectionView.register(WishEventCell.self, forCellWithReuseIdentifier: WishEventCell.reuseIdentifier)
        
        collectionView.pinHorizontal(to: self)
        collectionView.pinBottom(to: safeAreaLayoutGuide.bottomAnchor)
        collectionView.pinTop(to: safeAreaLayoutGuide.topAnchor)
    }
}
