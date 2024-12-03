//
//  WrittenWishCell.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.11.2024.
//

import UIKit

protocol AddWishCellDelegate: AnyObject {
    func didAddWishButtonPressed(with text: String)
}

final class AddWishCell: UITableViewCell {
    // MARK: - Constants
    private enum Constants {
        // animations
        static let wishTextViewTransformationAnimationDuration: CGFloat = 0.3
        
        // general to all
        static let borderWidth: CGFloat = 1.0
        static let borderColor: CGColor = UIColor.black.cgColor
        
        // view
        static let viewCellBackgroundColor: UIColor = .clear
        
        // wishTextView
        static let wishTextViewFontSize: CGFloat = 16
        static let wishTextViewTextColor: UIColor = .black
        static let wishTextViewBackgroundColor: UIColor = .white.withAlphaComponent(0.3)
        static let wishTextViewCornerRadius: CGFloat = 8.0
        static let wishTextViewLeadingIndent: CGFloat = 8
        static let wishTextViewTopIndent: CGFloat = 8
        static let wishTextViewStandardHeight: CGFloat = 36
        static let wishTextViewPlaceholderText: String = "Enter your deepest wish!"
        static let wishTextViewPlaceholderTextColor: UIColor = .gray
        
        // wishAddButton
        static let wishAddButtonTitle: String = "Add wish"
        static let wishAddButtonTitleColor: UIColor = .black
        static let wishAddButtonBackgroundColor: UIColor = .clear
        static let wishAddButtonCornerRadius: CGFloat = 8.0
        static let wishAddButtonLeadingIndent: CGFloat = 8
        static let wishAddButtonTopIndent: CGFloat = 8
        static let wishAddButtonBottomIndent: CGFloat = 8
        
        // wrap
        static let wrapColor: UIColor = .white.withAlphaComponent(0.25)
        static let wrapRadius: CGFloat = 16
        static let wrapLeadingIndent: CGFloat = 8
        static let wrapTopIndent: CGFloat = 8
    }
    
    static let reuseID: String = "AddWishCell"
    
    // MARK: - UI Components
    private let wishTextView: UITextView = UITextView()
    private let wishAddButton: UIButton = UIButton(type: .system)
    private let wrap: UIView = UIView()
    
    // MARK: - Variables
    weak var delegate: AddWishCellDelegate?
    private var wishTextViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = Constants.viewCellBackgroundColor
        
        configureWrap()
        configureWishTextView()
        configureWishAddButton()
    }
    
    private func configureWrap() {
        contentView.addSubview(wrap)
        
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        wrap.pinCenterX(to: contentView.centerXAnchor)
        wrap.pinCenterY(to: contentView.centerYAnchor)
        wrap.pinLeft(to: contentView.leadingAnchor, Constants.wrapLeadingIndent)
        wrap.pinTop(to: contentView.topAnchor, Constants.wrapTopIndent)
        
        wrap.addSubview(wishTextView)
        wrap.addSubview(wishAddButton)
    }
    
    private func configureWishTextView() {
        wishTextView.font = UIFont.systemFont(ofSize: Constants.wishTextViewFontSize)
        wishTextView.layer.borderColor = Constants.borderColor
        wishTextView.layer.borderWidth = Constants.borderWidth
        wishTextView.layer.cornerRadius = Constants.wishTextViewCornerRadius
        wishTextView.backgroundColor = Constants.wishTextViewBackgroundColor
        wishTextView.text = Constants.wishTextViewPlaceholderText
        wishTextView.textColor = Constants.wishTextViewPlaceholderTextColor
        wishTextView.isSelectable = true
        wishTextView.isEditable = true
        wishTextView.isUserInteractionEnabled = true
        
        wishTextView.pinTop(to: wrap.topAnchor, Constants.wishTextViewTopIndent)
        wishTextView.pinCenterX(to: wrap.centerXAnchor)
        wishTextView.pinLeft(to: wrap.leadingAnchor, Constants.wishTextViewLeadingIndent)
        wishTextViewHeightConstraint = wishTextView.setHeight(Constants.wishTextViewStandardHeight)
        wishTextView.delegate = self
    }
    
    private func configureWishAddButton() {
        wishAddButton.setTitle(Constants.wishAddButtonTitle, for: .normal)
        wishAddButton.setTitleColor(Constants.wishAddButtonTitleColor, for: .normal)
        wishAddButton.backgroundColor = Constants.wishAddButtonBackgroundColor
        wishAddButton.layer.borderWidth = Constants.borderWidth
        wishAddButton.layer.borderColor = Constants.borderColor
        wishAddButton.layer.cornerRadius = Constants.wishAddButtonCornerRadius
        
        wishAddButton.pinTop(to: wishTextView.bottomAnchor, Constants.wishAddButtonTopIndent)
        wishAddButton.pinBottom(to: wrap.bottomAnchor, Constants.wishAddButtonBottomIndent)
        wishAddButton.pinCenterX(to: wrap.centerXAnchor)
        wishAddButton.pinLeft(to: wrap.leadingAnchor, Constants.wishAddButtonLeadingIndent)
        
        wishAddButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func addWishButtonPressed() {
        guard let text = wishTextView.text, !text.isEmpty else { return }
        delegate?.didAddWishButtonPressed(with: text)
        
        wishTextViewHeightConstraint.constant = Constants.wishTextViewStandardHeight
        UIView.animate(withDuration: Constants.wishTextViewTransformationAnimationDuration, animations: {
            self.layoutIfNeeded()
        })
        
        wishTextView.text = ""
    }
}

// MARK: - UITextViewDelegate
extension AddWishCell: UITextViewDelegate {
    /// Track text editing and update heightConstraint
    func textViewDidChange(_ textView: UITextView) {
        // Subtract new text height
        let sizeThatFits = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = sizeThatFits.height
        
        // Update height if height has changed
        if newHeight != wishTextViewHeightConstraint.constant {
            wishTextViewHeightConstraint.constant = newHeight
            if let tableView = self.superview as? UITableView {
                UIView.animate(withDuration: Constants.wishTextViewTransformationAnimationDuration, animations: {
                        tableView.beginUpdates()
                        tableView.endUpdates()
                        self.layoutIfNeeded()
                })
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Remove the placeholder if the user starts typing text
        if textView.text == Constants.wishTextViewPlaceholderText {
            textView.text = ""
            textView.textColor = Constants.wishTextViewTextColor
            }
        }

    func textViewDidEndEditing(_ textView: UITextView) {
        // return the placeholder if the textView is empty
        if textView.text.isEmpty {
            textView.text = Constants.wishTextViewPlaceholderText
            textView.textColor = Constants.wishTextViewPlaceholderTextColor
        }
    }
}
