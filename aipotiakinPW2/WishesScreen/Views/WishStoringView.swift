//
//  WishStoringView.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.11.2024.
//

import Foundation
import UIKit

final class WishStoringView: UIView {
    // MARK: - Constants
    private enum Constants {
        // table
        static let tableBackgroundColor: UIColor = .lightGray
        static let tableCornerRadius: CGFloat = 20
        static let tableIndent: CGFloat = 20
    }
    
    private let table: UITableView = UITableView(frame: .zero)
    
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
    func configureTableDelegate(_ delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        table.delegate = delegate
        table.dataSource = dataSource
    }
    
    func reloadTable() {
        table.reloadData()
    }
    
    // MARK: - Private methods
    private func configureUI() {
        configureTable()
    }
    
    private func configureTable() {
        addSubview(table)
        table.backgroundColor = Constants.tableBackgroundColor
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        
        table.pin(to: self, Constants.tableIndent)
        
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseID)
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseID)
    }
}
