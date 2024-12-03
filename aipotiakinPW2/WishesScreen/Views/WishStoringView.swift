//
//  WishStoringView.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.11.2024.
//

import Foundation
import UIKit

// Протокол делегата для передачи событий
protocol WishStoringViewDelegate: AnyObject {
    func didCloseButtonPressed()
}

final class WishStoringView: UIView {
    // MARK: - Constants
    private enum Constants {
        // table
        static let tableBackgroundColor: UIColor = .clear
        static let tableCornerRadius: CGFloat = 20
        static let tableIndent: CGFloat = 20
        static let tableTopIndent: CGFloat = 10
        
        // closeButton
        static let closeButtonBackgroundColor: UIColor = .clear
        static let closeButtonTitle: String = "Close"
        static let closeButtonTintColor: UIColor = .systemBlue
        static let closeButtonTopIndent: CGFloat = 10
        static let closeButtonLeadingIndent: CGFloat = 10
        static let closeButtonHeight: CGFloat = 20
    }
    
    private let table: UITableView = UITableView(frame: .zero)
    private let closeButton: UIButton = UIButton(type: .system)
    weak var delegate: WishStoringViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        reloadTable()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configureTableDelegate(_ delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        table.delegate = delegate
        table.dataSource = dataSource
    }
    
    func reloadTable() {
        table.reloadData()
    }
    
    // MARK: - Private methods
    private func configureUI() {
        configureBackground()
        configureCloseButton()
        configureTable()
    }
    
    private func configureBackground() {
        backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurEffectView)
        
        blurEffectView.pinTop(to: topAnchor)
        blurEffectView.pinLeft(to: leadingAnchor)
        blurEffectView.pinRight(to: trailingAnchor)
        blurEffectView.pinBottom(to: bottomAnchor)
    }
    
    private func configureCloseButton() {
        addSubview(closeButton)
        closeButton.backgroundColor = Constants.closeButtonBackgroundColor
        closeButton.setTitle(Constants.closeButtonTitle, for: .normal)
        closeButton.tintColor = Constants.closeButtonTintColor
        closeButton.pinTop(to: safeAreaLayoutGuide.topAnchor, Constants.closeButtonTopIndent)
        closeButton.pinLeft(to: safeAreaLayoutGuide.leadingAnchor, Constants.closeButtonLeadingIndent)
        closeButton.setHeight(Constants.closeButtonHeight)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
    }
    
    private func configureTable() {
        addSubview(table)
        table.backgroundColor = Constants.tableBackgroundColor
        table.backgroundView = nil
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        
        //table.pin(to: self, Constants.tableIndent)
        table.pinTop(to: closeButton.bottomAnchor, Constants.tableTopIndent)
        table.pinBottom(to: safeAreaLayoutGuide.bottomAnchor)
        table.pinLeft(to: safeAreaLayoutGuide.leadingAnchor)
        table.pinRight(to: safeAreaLayoutGuide.trailingAnchor)
        
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseID)
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseID)
    }
    
    @objc
    private func closeButtonPressed() {
        delegate?.didCloseButtonPressed()
    }
}
