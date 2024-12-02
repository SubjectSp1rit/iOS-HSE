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
        
    }
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    let addEventButton: UIBarButtonItem = UIBarButtonItem()
    
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
        addEventButton.image = UIImage(systemName: "plus")
        addEventButton.style = .plain
        addEventButton.target = target
        navigationItem.rightBarButtonItem = addEventButton
    }
    
    func configureBar(in navigationBar: UINavigationBar?) {
        navigationBar?.isTranslucent = true
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
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
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.clipsToBounds = true
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            
            layout.invalidateLayout()
        }
        
        collectionView.register(WishEventCell.self, forCellWithReuseIdentifier: WishEventCell.reuseIdentifier)
        
        collectionView.pinHorizontal(to: self)
        collectionView.pinBottom(to: safeAreaLayoutGuide.bottomAnchor)
        collectionView.pinTop(to: safeAreaLayoutGuide.topAnchor)
    }
}
