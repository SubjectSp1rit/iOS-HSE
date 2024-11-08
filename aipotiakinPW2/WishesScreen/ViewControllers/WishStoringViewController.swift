//
//  WishStoringViewController.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.11.2024.
//

import Foundation
import UIKit

final class WishStoringViewController: UIViewController, AddWishCellDelegate, WrittenWishCellDelegate {
    // MARK: - Constants
    private enum Constants {
        // wishArray
        static let wishesKey: String = "wishArray"
        
        // table
        static let numberOfSections: Int = 2
    }
    
    private let wishStoringView = WishStoringView()
    private let defaults = UserDefaults.standard
    
    // MARK: - Variables
    private var wishArray: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        wishArray = defaults.array(forKey: Constants.wishesKey) as? [String] ?? []
        
        setView(to: wishStoringView)
        
        wishStoringView.configureTableDelegate(self, dataSource: self)
    }
    
    // MARK: - Methods
    func didAddWishButtonPressed(with text: String) {
        wishArray.append(text)
        saveChangesToDefaults()
        wishStoringView.reloadTable()
    }
    
    func didEditWishButtonPressed(with text: String) {
        let alertController = UIAlertController(title: "Edit Wish", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = text
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let newText = alertController.textFields?.first?.text, !newText.isEmpty else { return }
            if let index = self?.wishArray.firstIndex(of: text) {
                self?.wishArray[index] = newText
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
            if let index = wishArray.firstIndex(of: text) {
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
    
    // MARK: - Private Methods
    private func setView(to otherView: WishStoringView) {
        view.addSubview(otherView)
        otherView.setWidth(view.frame.width)
        otherView.setHeight(view.frame.height)
    }
    
    private func saveChangesToDefaults() {
        defaults.set(wishArray, forKey: Constants.wishesKey)
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
            
            return wishCell
        case 1:
            // WrittenWishCell
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseID, for: indexPath)
            
            guard let wishCell = cell as? WrittenWishCell else { return cell }
            wishCell.delegate = self
            
            wishCell.configure(with: wishArray[indexPath.row])
            
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
