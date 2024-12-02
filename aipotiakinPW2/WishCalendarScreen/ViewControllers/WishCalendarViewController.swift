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

    }
    
    var bgColor: UIColor?
    
    private let wishCalendarView = WishCalendarView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        wishCalendarView.configureBar(in: self.navigationController?.navigationBar)
        wishCalendarView.addEventButton.action = #selector(didAddEventButtonPressed)
    }
}

// MARK: - UICollectionViewDelegate
extension WishCalendarViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishEventCell.reuseIdentifier, for: indexPath)
        
        guard let wishEventCell = cell as? WishEventCell else { return cell }
        
        wishEventCell.configure(
            with: WishEventModel(
                title: "Test",
                description: "Test desc",
                startDate: "Start",
                endDate: "End"
            )
        )
        
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
        print("Cell tapped at index \(indexPath.item)")
    }
}

extension WishCalendarViewController {
    @objc func didAddEventButtonPressed() {
        let wishStoringViewController: WishStoringViewController = WishStoringViewController()
        
        present(wishStoringViewController, animated: true)
    }
}
