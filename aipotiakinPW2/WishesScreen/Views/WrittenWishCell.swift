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
}

final class WrittenWishCell: UITableViewCell {
    // MARK: - Constants
    private enum Constants {
        // general to buttons
        static let buttonBorderWidth: CGFloat = 1.0
        static let buttonBorderColor: CGColor = UIColor.black.cgColor
        static let buttonTitleColor: UIColor = .black
        static let buttonCornerRadius: CGFloat = 8.0
        
        // view
        static let viewCellBackgroundColor: UIColor = .clear
        
        // wrap
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 16
        static let wrapLeadingIndent: CGFloat = 8
        
        // wishLabel
        static let wishLabelLeadingIndent: CGFloat = 8
        static let wishLabelTrailingIndent: CGFloat = 8
        
        // deleteWishButton
        static let deleteWishButtonTitle: String = "Delete"
        static let deleteWishButtonBackgroundColor: UIColor = .red
        static let deleteWishButtonTrailingIndent: CGFloat = 8
        static let deleteWishButtonWidth: CGFloat = 60
        
        // editWishButton
        static let editWishButtonTitle: String = "Edit"
        static let editWishButtonBackgroundColor: UIColor = .gray
        static let editWishButtonTrailingIndent: CGFloat = 4
        static let editWishButtonWidth: CGFloat = 40
    }
    
    static let reuseID: String = "WrittenWishCell"
    
    private let wishLabel: UILabel = UILabel()
    private let editWishButton: UIButton = UIButton(type: .system)
    private let deleteWishButton: UIButton = UIButton(type: .system)
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
    func configure(with wish: String) {
        wishLabel.text = wish
    }
    
    // MARK: - Private methods
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = Constants.viewCellBackgroundColor
        
        configureWrap()
        configureButtons()
        configureWishLabel()
    }
    
    private func configureWrap() {
        contentView.addSubview(wrap)
        
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        wrap.pinCenterX(to: contentView.centerXAnchor)
        wrap.pinCenterY(to: contentView.centerYAnchor)
        wrap.pinLeft(to: contentView.leadingAnchor, Constants.wrapLeadingIndent)
        wrap.pinTop(to: contentView.topAnchor)
    }
    
    private func configureButtons() {
        // deleteWishButton
        wrap.addSubview(deleteWishButton)
        
        deleteWishButton.layer.borderWidth = Constants.buttonBorderWidth
        deleteWishButton.layer.borderColor = Constants.buttonBorderColor
        deleteWishButton.layer.cornerRadius = Constants.buttonCornerRadius
        deleteWishButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        deleteWishButton.setTitle(Constants.deleteWishButtonTitle, for: .normal)
        deleteWishButton.backgroundColor = Constants.deleteWishButtonBackgroundColor
        deleteWishButton.pinRight(to: wrap.trailingAnchor, Constants.deleteWishButtonTrailingIndent)
        deleteWishButton.setWidth(Constants.deleteWishButtonWidth)
        deleteWishButton.pinCenterY(to: wrap.centerYAnchor)
        deleteWishButton.addTarget(self, action: #selector(deleteWishButtonPressed), for: .touchUpInside)
        
        // editWishButton
        wrap.addSubview(editWishButton)
        
        editWishButton.layer.borderWidth = Constants.buttonBorderWidth
        editWishButton.layer.borderColor = Constants.buttonBorderColor
        editWishButton.layer.cornerRadius = Constants.buttonCornerRadius
        editWishButton.setTitleColor(Constants.buttonTitleColor, for: .normal)
        editWishButton.setTitle(Constants.editWishButtonTitle, for: .normal)
        editWishButton.backgroundColor = Constants.editWishButtonBackgroundColor
        editWishButton.pinRight(to: deleteWishButton.leadingAnchor, Constants.editWishButtonTrailingIndent)
        editWishButton.setWidth(Constants.editWishButtonWidth)
        editWishButton.pinCenterY(to: wrap.centerYAnchor)
        editWishButton.addTarget(self, action: #selector(editWishButtonPressed), for: .touchUpInside)
    }
    
    private func configureWishLabel() {
        wrap.addSubview(wishLabel)
        
        wishLabel.pinCenterY(to: wrap.centerYAnchor)
        wishLabel.pinLeft(to: wrap.leadingAnchor, Constants.wishLabelLeadingIndent)
        wishLabel.pinRight(to: editWishButton.leadingAnchor, Constants.wishLabelTrailingIndent)
    }
    
    @objc private func editWishButtonPressed() {
        guard let text = wishLabel.text else { return }
        delegate?.didEditWishButtonPressed(with: text)
    }
    
    @objc private func deleteWishButtonPressed() {
        guard let text = wishLabel.text else { return }
        delegate?.didDeleteWishButtonPressed(with: text)
    }
}
