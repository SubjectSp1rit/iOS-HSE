//
//  WishCalendarViewController.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 02.12.2024.
//

import Foundation
import UIKit

final class WishCalendarViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        // wishEventArray
        static let wishesKey: String = "wishEventArray"
    }
    
    let calendarManager = CalendarEventManager()
    
    // MARK: - UI Components
    private let wishCalendarView = WishCalendarView()
    
    // MARK: - Variables
    var bgColor: UIColor?
    private var wishEventArray: [WishEventModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromDefaults()
        // Удаляем все старые желания (чей срок прошел)
        deleteOldWishEvents()
        setView(to: wishCalendarView)
        wishCalendarView.configureCollectionViewDelegate(self, dataSource: self)
    }
    
    // MARK: - Private Methods
    private func setView(to otherView: WishCalendarView) {
        self.view = otherView
        
        // Передаем цвет фона
        if let bgColor = bgColor {
            (self.view as? WishCalendarView)?.configureBackground(with: bgColor)
        }
        
        // Настраиваем бар
        wishCalendarView.configureAddEventButton(in: navigationItem, self)
        wishCalendarView.configureBar(in: self.navigationController?.navigationBar, vc: self)
        wishCalendarView.addEventButton.action = #selector(didAddEventButtonPressed)
        
        // Ставим картинку, если желаний нет
        if (wishEventArray.isEmpty) {
            wishCalendarView.configureNoWishesImage(mode: "add")
        }
    }
    
    private func loadDataFromDefaults() {
        wishEventArray = UserDefaultsManager.shared.load(forKey: Constants.wishesKey)
    }
    
    private func saveChangesToDefaults() {
        UserDefaultsManager.shared.save(wishEventArray, forKey: Constants.wishesKey)
    }
    
    private func deleteOldWishEvents() {
        let currentDate = Date()
        
        wishEventArray.removeAll { $0.endDate < currentDate }
    }
}

// MARK: - UICollectionViewDelegate
extension WishCalendarViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishEventArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishEventCell.reuseIdentifier, for: indexPath)
        
        guard let wishEventCell = cell as? WishEventCell else { return cell }
        
        wishEventCell.delegate = self
        wishEventCell.configure(with: wishEventArray[indexPath.row])
        
        return wishEventCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adjust cell size as needed
        return CGSize(width: collectionView.bounds.width - 10, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - AddElementDelegate
extension WishCalendarViewController: AddElementDelegate {
    @objc func didAddEventButtonPressed() {
        let addWishEventViewController: AddWishEventViewController = AddWishEventViewController()
        addWishEventViewController.delegate = self
        present(addWishEventViewController, animated: true)
    }
    
    func didAddElement(_ element: WishEventModel, _ isSwitchPressed: Bool) {
        wishEventArray.append(element)
        wishCalendarView.reloadTable()
        saveChangesToDefaults()
        wishCalendarView.configureNoWishesImage(mode: "delete")
        
        // Если пользователь нажал переключатель - добавляем событие в календарь
        if isSwitchPressed {
            calendarManager.create(eventModel: element)
        }
    }
}

// MARK: - WishEventCellDelegate
extension WishCalendarViewController: WishEventCellDelegate {
    func didDeleteWishEventButtonPressed(title: String) {
        let alertController = UIAlertController(
            title: "Confirm Deletion",
            message: "Are you sure you want to delete \"\(title)\"?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            if let index = wishEventArray.firstIndex(where: { $0.title == title }) {
                wishEventArray.remove(at: index)
                wishCalendarView.reloadTable()
                saveChangesToDefaults()
                if (wishEventArray.isEmpty) {
                    wishCalendarView.configureNoWishesImage(mode: "add")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }   
}
