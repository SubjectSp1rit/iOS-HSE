//
//  CustomSlider.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 30.10.2024.
//

import Foundation
import UIKit

final class CustomSlider: UIView {
    // MARK: - Constants
    private enum Constants {
        // title
        static let titleLeadingIndent: CGFloat = 20
        static let titleTopIndent: CGFloat = 10
        
        // slider
        static let sliderLeadingIndent: CGFloat = 20
        static let sliderBottomIndent: CGFloat = 10
    }
    
    // MARK: - Variables
    var valueChanged: ((Double) -> Void)?
    
    // MARK: - UI Components
    var slider = UISlider()
    var titleView = UILabel()
    
    // MARK: - Lifecycle
    init(title: String, min: Double, max: Double, textColor titleTextColor: UIColor = .black) {
        super.init(frame: .zero)
        titleView.text = title
        titleView.textColor = titleTextColor
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func configureUI() {
        backgroundColor = .white
        
        configureTitle()
        configureSlider()
    }
    
    private func configureTitle() {
        addSubview(titleView)
        titleView.pinCenterX(to: centerXAnchor)
        titleView.pinLeft(to: leadingAnchor, Constants.titleLeadingIndent)
        titleView.pinTop(to: topAnchor, Constants.titleTopIndent)
    }
    
    private func configureSlider() {
        addSubview(slider)
        slider.pinCenterX(to: centerXAnchor)
        slider.pinTop(to: titleView.bottomAnchor)
        slider.pinBottom(to: bottomAnchor, Constants.sliderBottomIndent)
        slider.pinLeft(to: leadingAnchor, Constants.sliderLeadingIndent)
    }
    
    @objc
    private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
    }
}
