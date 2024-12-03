//
//  WrittenWishCell.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.11.2024.
//

import UIKit

protocol WrittenWishCellDelegate: AnyObject {
    func didEditWishButtonPressed(with text: String)
    func didDeleteWishButtonPressed(with text: String)
    func didScheduleWishButtonPressed(with text: String)
}

final class WrittenWishCell: UITableViewCell {
    // MARK: - Constants
    private enum Constants {
        // general to buttons
        static let buttonTopIndent: CGFloat = 5
        static let buttonBottomIndent: CGFloat = 5
        static let buttonHeight: CGFloat = 28
        static let buttonWidth: CGFloat = 28
        
        // view
        static let viewCellBackgroundColor: UIColor = .clear
        
        // wrap
        static let wrapColor: UIColor = .white.withAlphaComponent(0.25)
        static let wrapMinRadius: CGFloat = 0
        static let wrapMaxRadius: CGFloat = 16
        static let wrapLeadingIndent: CGFloat = 8
        
        // wishLabel
        static let wishLabelTextColor: UIColor = .black
        static let wishLabelLeadingIndent: CGFloat = 8
        static let wishLabelTrailingIndent: CGFloat = 8
        
        // deleteWishButton
        static let deleteWishButtonTrailingIndent: CGFloat = 8
        static let deleteWishButtonImageName: String = "binIcon"
        static let deleteWishButtonTintColor: UIColor = .systemRed
        
        // editWishButton
        static let editWishButtonTrailingIndent: CGFloat = 4
        static let editWishButtonImageName: String = "settingsIcon"
        static let editWishButtonTintColor: UIColor = .darkGray
        
        // scheduleWishButton
        static let scheduleWishButtonTrailingIndent: CGFloat = 4
        static let scheduleWishButtonImageName: String = "calendarIcon"
        static let scheduleWishButtonTintColor: UIColor = .systemBlue
    }
    
    static let reuseID: String = "WrittenWishCell"
    
    private let wishLabel: UILabel = UILabel()
    private let editWishButton: UIButton = UIButton(type: .system)
    private let deleteWishButton: UIButton = UIButton(type: .system)
    private let scheduleWishButton: UIButton = UIButton(type: .system)
    private let wrap: UIView = UIView()
    
    // MARK: - Variables
    weak var delegate: WrittenWishCellDelegate?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func configure(with wish: Wish) {
        wishLabel.text = wish.title
    }
    
    /// Configures edge rounding
    func configureCorners(isFirst: Bool, isLast: Bool) {
        wrap.layer.cornerRadius = Constants.wrapMaxRadius
        if isFirst && isLast {
            wrap.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner] // round all corners
        } else if isFirst {
            wrap.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // round only top corners (for the first elem)
        } else if isLast {
            wrap.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // round only bottom corners (for the last elem)
        } else {
            wrap.layer.cornerRadius = Constants.wrapMinRadius // do not round corners (middle elements)
        }
    }
    
    // MARK: - Private methods
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = Constants.viewCellBackgroundColor
        
        configureWrap()
        configureButtons()
        configureScheduleWishButton()
        configureWishLabel()
    }
    
    private func configureWrap() {
        contentView.addSubview(wrap)
        
        wrap.backgroundColor = Constants.wrapColor
        wrap.pinCenterX(to: contentView.centerXAnchor)
        wrap.pinCenterY(to: contentView.centerYAnchor)
        wrap.pinLeft(to: contentView.leadingAnchor, Constants.wrapLeadingIndent)
        wrap.pinTop(to: contentView.topAnchor)
    }
    
    private func configureScheduleWishButton() {
        wrap.addSubview(scheduleWishButton)
        
        scheduleWishButton.setImage(UIImage(named: Constants.scheduleWishButtonImageName), for: .normal)
        scheduleWishButton.tintColor = Constants.scheduleWishButtonTintColor
        scheduleWishButton.pinRight(to: editWishButton.leadingAnchor, Constants.scheduleWishButtonTrailingIndent)
        scheduleWishButton.pinCenterY(to: wrap.centerYAnchor)
        scheduleWishButton.pinTop(to: wrap.topAnchor, Constants.buttonTopIndent)
        scheduleWishButton.pinBottom(to: wrap.bottomAnchor, Constants.buttonBottomIndent)
        scheduleWishButton.setHeight(Constants.buttonHeight)
        scheduleWishButton.setWidth(Constants.buttonWidth)
        scheduleWishButton.addTarget(self, action: #selector(scheduleWishButtonPressed), for: .touchUpInside)
    }
    
    private func configureButtons() {
        // deleteWishButton
        wrap.addSubview(deleteWishButton)
        
        deleteWishButton.setImage(UIImage(named: Constants.deleteWishButtonImageName), for: .normal)
        deleteWishButton.tintColor = Constants.deleteWishButtonTintColor
        deleteWishButton.pinRight(to: wrap.trailingAnchor, Constants.deleteWishButtonTrailingIndent)
        deleteWishButton.pinCenterY(to: wrap.centerYAnchor)
        deleteWishButton.pinTop(to: wrap.topAnchor, Constants.buttonTopIndent)
        deleteWishButton.pinBottom(to: wrap.bottomAnchor, Constants.buttonBottomIndent)
        deleteWishButton.setHeight(Constants.buttonHeight)
        deleteWishButton.setWidth(Constants.buttonWidth)
        deleteWishButton.addTarget(self, action: #selector(deleteWishButtonPressed), for: .touchUpInside)
        
        // editWishButton
        wrap.addSubview(editWishButton)
        
        editWishButton.setImage(UIImage(named: Constants.editWishButtonImageName), for: .normal)
        editWishButton.tintColor = Constants.editWishButtonTintColor
        editWishButton.pinRight(to: deleteWishButton.leadingAnchor, Constants.editWishButtonTrailingIndent)
        editWishButton.pinCenterY(to: wrap.centerYAnchor)
        editWishButton.pinTop(to: wrap.topAnchor, Constants.buttonTopIndent)
        editWishButton.pinBottom(to: wrap.bottomAnchor, Constants.buttonBottomIndent)
        editWishButton.setHeight(Constants.buttonHeight)
        editWishButton.setWidth(Constants.buttonWidth)
        editWishButton.addTarget(self, action: #selector(editWishButtonPressed), for: .touchUpInside)
    }
    
    private func configureWishLabel() {
        wrap.addSubview(wishLabel)
        
        wishLabel.textColor = Constants.wishLabelTextColor
        wishLabel.pinCenterY(to: wrap.centerYAnchor)
        wishLabel.pinLeft(to: wrap.leadingAnchor, Constants.wishLabelLeadingIndent)
        wishLabel.pinRight(to: scheduleWishButton.leadingAnchor, Constants.wishLabelTrailingIndent)
    }
    
    @objc private func editWishButtonPressed() {
        guard let text = wishLabel.text else { return }
        delegate?.didEditWishButtonPressed(with: text)
    }
    
    @objc private func deleteWishButtonPressed() {
        guard let text = wishLabel.text else { return }
        delegate?.didDeleteWishButtonPressed(with: text)
    }
    
    @objc private func scheduleWishButtonPressed() {
        guard let text = wishLabel.text else { return }
        delegate?.didScheduleWishButtonPressed(with: text)
    }
}
