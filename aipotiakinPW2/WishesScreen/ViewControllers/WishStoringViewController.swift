//
//  WishStoringViewController.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.11.2024.
//

import Foundation
import UIKit

final class WishStoringViewController: UIViewController {
    // MARK: - Constants
    private let wishStoringView = WishStoringView()
    
    // MARK: - Variables
    private var wishArray: [String] = ["I wish add cells to the table"]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView(to: wishStoringView)
        
        wishStoringView.configureTableDelegate(self, dataSource: self)
    }
    
    // MARK: - Private Methods
    private func setView(to otherView: WishStoringView) {
        view.addSubview(otherView)
        otherView.setWidth(view.frame.width)
        otherView.setHeight(view.frame.height)
    }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseID,
                                                 for: indexPath)
        
        guard let wishCell = cell as? WrittenWishCell else { return cell }
        
        wishCell.configure(with: wishArray[indexPath.row])
        
        return wishCell
    }
}

// MARK: - UITableViewDelegate
extension WishStoringViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
