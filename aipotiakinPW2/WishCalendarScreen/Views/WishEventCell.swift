//
//  WishEventCell.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 02.12.2024.
//

import Foundation
import UIKit

protocol WishEventCellDelegate: AnyObject {
    func didDeleteWishEventButtonPressed(title: String)
}

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
        
        // deleteWishEventButton
        static let deleteWishEventButtonTrailingIndent: CGFloat = 8
        static let deleteWishEventButtonImageName: String = "binIcon"
        static let deleteWishEventButtonTintColor: UIColor = .systemRed
        static let deleteWishEventButtonHeight: CGFloat = 28
        static let deleteWishEventButtonWidth: CGFloat = 28
    }
    
    static let reuseIdentifier: String = "WishEventCell"
    
    private let wrap: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let startDateLabel: UILabel = UILabel()
    private let endDateLabel: UILabel = UILabel()
    private let deleteWishEventButton: UIButton = UIButton(type: .system)
    
    // MARK: - Variables
    weak var delegate: WishEventCellDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureWrap()
        configureDeleteWishEventButton()
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
        addSubview(wrap)
        
        wrap.pin(to: self, Constants.wrapIndent)
        wrap.layer.cornerRadius = Constants.wrapCornerRadius
        wrap.backgroundColor = Constants.wrapBackgroundColor
    }
    
    private func configureDeleteWishEventButton() {
        wrap.addSubview(deleteWishEventButton)
        
        deleteWishEventButton.setImage(UIImage(named: Constants.deleteWishEventButtonImageName), for: .normal)
        deleteWishEventButton.tintColor = Constants.deleteWishEventButtonTintColor
        deleteWishEventButton.pinRight(to: wrap.trailingAnchor, Constants.deleteWishEventButtonTrailingIndent)
        deleteWishEventButton.pinCenterY(to: wrap.centerYAnchor)
        deleteWishEventButton.setHeight(Constants.deleteWishEventButtonHeight)
        deleteWishEventButton.setWidth(Constants.deleteWishEventButtonWidth)
        deleteWishEventButton.addTarget(self, action: #selector(deleteWishEventButtonPressed), for: .touchUpInside)
    }
    
    private func configureTitleLabel() {
        wrap.addSubview(titleLabel)
        
        titleLabel.textColor = Constants.labelTextColor
        titleLabel.pinTop(to: wrap.topAnchor, Constants.titleLabelTopIndent)
        titleLabel.pinLeft(to: wrap.leadingAnchor, Constants.titleLabelLeadingIndent)
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize)
        titleLabel.sizeToFit()
    }
    
    private func configureDescriptionLabel() {
        wrap.addSubview(descriptionLabel)
        
        descriptionLabel.textColor = Constants.labelTextColor
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionLabelTopIndent)
        descriptionLabel.pinLeft(to: wrap.leadingAnchor, Constants.descriptionLabelLeadingIndent)
        descriptionLabel.pinBottom(to: wrap.bottomAnchor, Constants.descriptionLabelBottomIndent)
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.descriptionLabelFontSize)
    }
    
    private func configureStartDateLabel() {
        wrap.addSubview(startDateLabel)
        
        startDateLabel.textColor = Constants.labelTextColor
        startDateLabel.pinTop(to: wrap.topAnchor, Constants.startDateLabelTopIndent)
        startDateLabel.pinRight(to: wrap.trailingAnchor, Constants.startDateLabelTrailingIndent)
        startDateLabel.font = UIFont.systemFont(ofSize: Constants.startDateLabelFontSize)
        startDateLabel.sizeToFit()
    }
    
    private func configureEndDateLabel() {
        wrap.addSubview(endDateLabel)
        
        endDateLabel.textColor = Constants.labelTextColor
        endDateLabel.pinBottom(to: wrap.bottomAnchor, Constants.endDateLabelBottomIndent)
        endDateLabel.pinRight(to: wrap.trailingAnchor, Constants.endDateLabelTrailingIndent)
        endDateLabel.font = UIFont.systemFont(ofSize: Constants.endDateLabelFontSize)
        endDateLabel.sizeToFit()
    }
    
    @objc
    private func deleteWishEventButtonPressed() {
        guard let titleLabelText = titleLabel.text else { return }
        delegate?.didDeleteWishEventButtonPressed(title: titleLabelText)
    }
}
