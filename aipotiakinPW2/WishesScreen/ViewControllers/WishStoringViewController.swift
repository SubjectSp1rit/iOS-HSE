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
    private enum Constants {
        // wishArray
        static let wishesKey: String = "wishArray"
        
        // table
        static let numberOfSections: Int = 2
    }
    
    private let wishStoringView = WishStoringView()
    
    // MARK: - Variables
    private var wishArray: [Wish] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromDefaults()
        setView(to: wishStoringView)
        wishStoringView.delegate = self
        wishStoringView.configureTableDelegate(self, dataSource: self)
    }
    
    // MARK: - Private Methods
    private func setView(to otherView: WishStoringView) {
        self.view = otherView
    }
    
    private func loadDataFromDefaults() {
        wishArray = UserDefaultsManager.shared.load(forKey: Constants.wishesKey)
    }
    
    private func saveChangesToDefaults() {
        UserDefaultsManager.shared.save(wishArray, forKey: Constants.wishesKey)
    }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return wishArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // AddWishCell
            let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseID, for: indexPath) 
            
            guard let wishCell = cell as? AddWishCell else { return cell }
            wishCell.delegate = self
            wishCell.selectionStyle = .none
            
            return wishCell
        case 1:
            // WrittenWishCell
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseID, for: indexPath)
            
            guard let wishCell = cell as? WrittenWishCell else { return cell }
            wishCell.delegate = self
            wishCell.selectionStyle = .none
            
            wishCell.configure(with: wishArray[indexPath.row])
            
            // Закругляем края ячейки
            let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
            let isFirst = indexPath.row == 0
            let isLast = indexPath.row == numberOfRows - 1
            wishCell.configureCorners(isFirst: isFirst, isLast: isLast)
            
            return wishCell
        default:
            fatalError("Unkown section")
        }
    }
}

// MARK: - UITableViewDelegate
extension WishStoringViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - AddWishCellDelegate
extension WishStoringViewController: AddWishCellDelegate {
    func didAddWishButtonPressed(with text: String) {
        let newWish = Wish(title: text)
        wishArray.append(newWish)
        saveChangesToDefaults()
        wishStoringView.reloadTable()
    }
}

// MARK: - WrittenWishCellDelegate
extension WishStoringViewController: WrittenWishCellDelegate {
    func didEditWishButtonPressed(with text: String) {
        let alertController = UIAlertController(title: "Edit Wish", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = text
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let newText = alertController.textFields?.first?.text, !newText.isEmpty else { return }
            if let index = self?.wishArray.firstIndex(where: { $0.title == text }) {
                let newWish = Wish(title: newText)
                self?.wishArray[index] = newWish
                self?.saveChangesToDefaults()
                self?.wishStoringView.reloadTable()
            }
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func didDeleteWishButtonPressed(with text: String) {
        let alertController = UIAlertController(
            title: "Confirm Deletion",
            message: "Are you sure you want to delete \"\(text)\"?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            if let index = wishArray.firstIndex(where: { $0.title == text }) {
                wishArray.remove(at: index)
                wishStoringView.reloadTable()
                saveChangesToDefaults()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - WishStoringViewDelegate
extension WishStoringViewController: WishStoringViewDelegate {
    func didCloseButtonPressed() {
        dismiss(animated: true)
    }
}
