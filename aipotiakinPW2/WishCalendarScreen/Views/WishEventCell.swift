//
//  WishEventCell.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 02.12.2024.
//

import Foundation
import UIKit

final class WishEventCell: UICollectionViewCell {
    // MARK: - Constants
    private enum Constants {
        // general to all labels
        static let labelTextColor: UIColor = .black
        
        // wrapView
        static let wrapIndent: CGFloat = 10
        static let wrapCornerRadius: CGFloat = 16
        static let wrapBackgroundColor: UIColor = .black.withAlphaComponent(0.15)
        
        // titleLabel
        static let titleLabelTopIndent: CGFloat = 8
        static let titleLabelLeadingIndent: CGFloat = 8
        static let titleLabelFontSize: CGFloat = 24
        
        // descriptionLabel
        static let descriptionLabelTopIndent: CGFloat = 4
        static let descriptionLabelLeadingIndent: CGFloat = 8
        static let descriptionLabelBottomIndent: CGFloat = 8
        static let descriptionLabelFontSize: CGFloat = 16
        
        // startDateLabel
        static let startDateLabelTopIndent: CGFloat = 8
        static let startDateLabelTrailingIndent: CGFloat = 8
        static let startDateLabelFontSize: CGFloat = 12
        
        // endDateLabel
        static let endDateLabelBottomIndent: CGFloat = 8
        static let endDateLabelTrailingIndent: CGFloat = 8
        static let endDateLabelFontSize: CGFloat = 12
    }
    
    static let reuseIdentifier: String = "WishEventCell"
    
    private let wrapView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let startDateLabel: UILabel = UILabel()
    private let endDateLabel: UILabel = UILabel()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureWrap()
        configureTitleLabel()
        configureStartDateLabel()
        configureEndDateLabel()
        configureDescriptionLabel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Cell Configuration
    func configure(with event: WishEventModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        formatter.timeZone = TimeZone.current
        
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        startDateLabel.text = "Start Date: \(formatter.string(from: event.startDate))"
        endDateLabel.text = "End Date: \(formatter.string(from: event.endDate))"
    }
    
    // MARK: - UI Configuration
    private func configureWrap() {
        addSubview(wrapView)
        
        wrapView.pin(to: self, Constants.wrapIndent)
        wrapView.layer.cornerRadius = Constants.wrapCornerRadius
        wrapView.backgroundColor = Constants.wrapBackgroundColor
    }
    
    private func configureTitleLabel() {
        wrapView.addSubview(titleLabel)
        
        titleLabel.textColor = Constants.labelTextColor
        titleLabel.pinTop(to: wrapView.topAnchor, Constants.titleLabelTopIndent)
        titleLabel.pinLeft(to: wrapView.leadingAnchor, Constants.titleLabelLeadingIndent)
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize)
        titleLabel.sizeToFit()
    }
    
    private func configureDescriptionLabel() {
        wrapView.addSubview(descriptionLabel)
        
        descriptionLabel.textColor = Constants.labelTextColor
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionLabelTopIndent)
        descriptionLabel.pinLeft(to: wrapView.leadingAnchor, Constants.descriptionLabelLeadingIndent)
        descriptionLabel.pinBottom(to: wrapView.bottomAnchor, Constants.descriptionLabelBottomIndent)
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.descriptionLabelFontSize)
    }
    
    private func configureStartDateLabel() {
        wrapView.addSubview(startDateLabel)
        
        startDateLabel.textColor = Constants.labelTextColor
        startDateLabel.pinTop(to: wrapView.topAnchor, Constants.startDateLabelTopIndent)
        startDateLabel.pinRight(to: wrapView.trailingAnchor, Constants.startDateLabelTrailingIndent)
        startDateLabel.font = UIFont.systemFont(ofSize: Constants.startDateLabelFontSize)
        startDateLabel.sizeToFit()
    }
    
    private func configureEndDateLabel() {
        wrapView.addSubview(endDateLabel)
        
        endDateLabel.textColor = Constants.labelTextColor
        endDateLabel.pinBottom(to: wrapView.bottomAnchor, Constants.endDateLabelBottomIndent)
        endDateLabel.pinRight(to: wrapView.trailingAnchor, Constants.endDateLabelTrailingIndent)
        endDateLabel.font = UIFont.systemFont(ofSize: Constants.endDateLabelFontSize)
        endDateLabel.sizeToFit()
    }
}
