//
//  WrittenWishCell.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.11.2024.
//

import UIKit

final class WrittenWishCell: UITableViewCell {
    // MARK: - Constants
    static let reuseID: String = "WrittenWishCell"
    
    private enum Constants {
        // view
        static let viewCellBackgroundColor: UIColor = .clear
        
        // wrap
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 5
        static let wrapOffsetH: CGFloat = 10
        static let wishLabelOffset: CGFloat = 8
    }
    
    private let wishLabel: UILabel = UILabel()
    
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
        
        let wrap: UIView = UIView()
        addSubview(wrap)
        
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        wrap.pinVertical(to: self, Constants.wrapOffsetV)
        wrap.pinHorizontal(to: self, Constants.wrapOffsetH)
        
        wrap.addSubview(wishLabel)
        wishLabel.pinTop(to: wrap, Constants.wishLabelOffset)
    }
}
