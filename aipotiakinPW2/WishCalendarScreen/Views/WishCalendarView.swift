//
//  WishCalendarView.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 02.12.2024.
//

import Foundation
import UIKit

final class WishCalendarView: UIView {
    // MARK: - Constants
    private enum Constants {
        
    }
    
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
    func configureBackground(with bgColor: UIColor) {
        backgroundColor = bgColor
    }
    
    // MARK: - Private methods
    private func configureUI() {
    }
}
