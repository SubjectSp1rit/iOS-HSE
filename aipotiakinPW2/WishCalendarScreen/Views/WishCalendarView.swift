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
    
    // MARK: - Private methods
    private func configureUI() {
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        addSubview(collectionView)
        collectionView.backgroundColor = .cyan
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.pinHorizontal(to: self)
        collectionView.pinBottom(to: safeAreaLayoutGuide.bottomAnchor)
        collectionView.pinTop(to: safeAreaLayoutGuide.topAnchor)
    }
}
