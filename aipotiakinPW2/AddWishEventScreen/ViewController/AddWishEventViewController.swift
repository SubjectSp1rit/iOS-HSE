//
//  WishStoringViewController.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.11.2024.
//

import Foundation
import UIKit

final class AddWishEventViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
    }
    
    private let addWishEventView = AddWishEventView()
    
    // MARK: - Variables
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView(to: addWishEventView)
        addWishEventView.delegate = self
        addWishEventView.configurePickerViewDelegate(self, datasource: self)
    }
    
    // MARK: - Private Methods
    private func setView(to otherView: UIView) {
        self.view = otherView
    }
}

extension AddWishEventViewController: AddWishEventViewDelegate {
    func didCloseButtonPressed() {
        dismiss(animated: true)
    }
}

extension AddWishEventViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
}

extension AddWishEventViewController: UIPickerViewDelegate {
    
}
