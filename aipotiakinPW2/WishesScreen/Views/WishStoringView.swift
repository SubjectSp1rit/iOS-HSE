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
    
    // MARK: - Private methods
    private func configureUI() {
        configureTable()
    }
    
    private func configureTable() {
        addSubview(table)
        table.backgroundColor = .red
        table.separatorStyle = .none
        table.layer.cornerRadius = 20
        
        table.pin(to: self, 20)
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}
