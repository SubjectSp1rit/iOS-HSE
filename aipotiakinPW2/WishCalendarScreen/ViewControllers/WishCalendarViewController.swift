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
    }
    
    // MARK: - Private Methods
    private func setView(to otherView: WishCalendarView) {
        self.view = otherView
        
        if let bgColor = bgColor {
            (self.view as? WishCalendarView)?.configureBackground(with: bgColor)
        }
    }
}
