//
//  ViewController.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 28.10.2024.
//

import UIKit

final class WishMakerViewController: UIViewController {
    // MARK: - Constants
    private let wishMakerView = WishMakerView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wishMakerView.delegate = self
        setView(to: wishMakerView)
    }
    
    // MARK: - Private methods
    private func setView(to otherView: WishMakerView) {
        self.view = otherView
    }
}

// MARK: - WishMakerViewDelegate
extension WishMakerViewController: WishMakerViewDelegate {
    func didAddWishButtonPressed() {
        let wishStoringViewController: WishStoringViewController = WishStoringViewController()
        
        present(wishStoringViewController, animated: true)
    }
    
    func didScheduleWishButtonPressed() {
        let vc = WishCalendarViewController()
        vc.modalPresentationStyle = .overCurrentContext // Позволяет сделать фон прозрачным
        vc.bgColor = wishMakerView.currentBackgroundColor
        navigationController?.pushViewController(vc, animated: true)
    }
}
