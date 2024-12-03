//
//  WishStoringView.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.11.2024.
//

import Foundation
import UIKit

protocol AddWishEventViewDelegate: AnyObject {
    func didCloseButtonPressed()
}

final class AddWishEventView: UIView {
    // MARK: - Constants
    private enum Constants {
        // general to all
        static let borderWidth: CGFloat = 1.0
        static let borderColor: CGColor = UIColor.black.cgColor
        static let leadingIndent: CGFloat = 8
        static let topIndent: CGFloat = 8
        
        // general to textView
        static let textViewFontSize: CGFloat = 16
        static let textViewTextColor: UIColor = .black
        static let textViewPlaceholderTextColor: UIColor = .lightGray
        static let textViewBackgroundColor: UIColor = .clear
        static let textViewCornerRadius: CGFloat = 8.0
        static let textViewStandardHeight: CGFloat = 36
        
        // titleTextView
        static let titleTextViewPlaceholderText: String = "Введите заголовок"
        
        // descriptionTextView
        static let descriptionTextViewPlaceholderText: String = "Введите описание"
        
        // closeButton
        static let closeButtonBackgroundColor: UIColor = .clear
        static let closeButtonTitle: String = "Close"
        static let closeButtonTintColor: UIColor = .systemBlue
        static let closeButtonTopIndent: CGFloat = 10
        static let closeButtonLeadingIndent: CGFloat = 10
        static let closeButtonHeight: CGFloat = 20
        
        static let loopMultiplier = 10000 // Константа для зацикливания
    }
    
    // MARK: - Variables
    weak var delegate: AddWishEventViewDelegate?
    var days = Array(1...31).map { "\($0)" }
    var months = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    let hours = Array(0...23).map { String(format: "%02d", $0) } // Часы от 00 до 23
    let minutes = Array(0...59).map { String(format: "%02d", $0) } // Минуты от 00 до 59
    
    // MARK: - UI Components
    private let closeButton: UIButton = UIButton(type: .system)
    private let titleTextView: UITextView = UITextView()
    private let descriptionTextView: UITextView = UITextView()
    private let startDatePickerView: UIPickerView = UIPickerView()
    private let endDatePickerView: UIPickerView = UIPickerView()
    
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
    func configurePickerView(to date: Date) {
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: date)
        let currentMonth = calendar.component(.month, from: date)
        let currentHour = calendar.component(.hour, from: date)
        let currentMinute = calendar.component(.minute, from: date)
        
        for pickerView in [startDatePickerView, endDatePickerView] {
            pickerView.selectRow(currentDay - 1, inComponent: 0, animated: true) // День
            pickerView.selectRow(currentMonth - 1, inComponent: 1, animated: true) // Месяц
            pickerView.selectRow(currentHour, inComponent: 2, animated: true) // Часы
            pickerView.selectRow(currentMinute, inComponent: 3, animated: true) // Минуты
        }
    }
    
    func configurePickerViewDelegate(_ delegate: UIPickerViewDelegate, datasource: UIPickerViewDataSource) {
        startDatePickerView.dataSource = datasource
        startDatePickerView.delegate = delegate
        
        endDatePickerView.dataSource = datasource
        endDatePickerView.delegate = delegate
    }
    
    // MARK: - Private methods
    private func configureUI() {
        configureBackground()
        configureCloseButton()
        configureTitleTextView()
        configureDescriptionTextView()
        configureStartDatePickerView()
        configureEndDatePickerView()
    }
    
    private func configureBackground() {
        backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurEffectView)
        
        blurEffectView.pinTop(to: topAnchor)
        blurEffectView.pinLeft(to: leadingAnchor)
        blurEffectView.pinRight(to: trailingAnchor)
        blurEffectView.pinBottom(to: bottomAnchor)
    }
    
    private func configureCloseButton() {
        addSubview(closeButton)
        closeButton.backgroundColor = Constants.closeButtonBackgroundColor
        closeButton.setTitle(Constants.closeButtonTitle, for: .normal)
        closeButton.tintColor = Constants.closeButtonTintColor
        closeButton.pinTop(to: safeAreaLayoutGuide.topAnchor, Constants.closeButtonTopIndent)
        closeButton.pinLeft(to: safeAreaLayoutGuide.leadingAnchor, Constants.closeButtonLeadingIndent)
        closeButton.setHeight(Constants.closeButtonHeight)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
    }
    
    private func configureTitleTextView() {
        addSubview(titleTextView)
        
        titleTextView.font = UIFont.systemFont(ofSize: Constants.textViewFontSize)
        titleTextView.layer.borderColor = Constants.borderColor
        titleTextView.layer.borderWidth = Constants.borderWidth
        titleTextView.layer.cornerRadius = Constants.textViewCornerRadius
        titleTextView.backgroundColor = Constants.textViewBackgroundColor
        titleTextView.textColor = Constants.textViewPlaceholderTextColor
        titleTextView.text = Constants.titleTextViewPlaceholderText
        titleTextView.setHeight(Constants.textViewStandardHeight)
        titleTextView.isSelectable = true
        titleTextView.isEditable = true
        titleTextView.isUserInteractionEnabled = true
        titleTextView.delegate = self
        titleTextView.tag = 1
        
        titleTextView.pinTop(to: closeButton.bottomAnchor, Constants.topIndent)
        titleTextView.pinCenterX(to: centerXAnchor)
        titleTextView.pinLeft(to: leadingAnchor, Constants.leadingIndent)
    }
    
    private func configureDescriptionTextView() {
        addSubview(descriptionTextView)
        
        descriptionTextView.font = UIFont.systemFont(ofSize: Constants.textViewFontSize)
        descriptionTextView.layer.borderColor = Constants.borderColor
        descriptionTextView.layer.borderWidth = Constants.borderWidth
        descriptionTextView.layer.cornerRadius = Constants.textViewCornerRadius
        descriptionTextView.backgroundColor = Constants.textViewBackgroundColor
        descriptionTextView.textColor = Constants.textViewPlaceholderTextColor
        descriptionTextView.text = Constants.descriptionTextViewPlaceholderText
        descriptionTextView.setHeight(Constants.textViewStandardHeight)
        descriptionTextView.isSelectable = true
        descriptionTextView.isEditable = true
        descriptionTextView.isUserInteractionEnabled = true
        descriptionTextView.delegate = self
        descriptionTextView.tag = 2
        
        descriptionTextView.pinTop(to: titleTextView.bottomAnchor, Constants.topIndent)
        descriptionTextView.pinCenterX(to: centerXAnchor)
        descriptionTextView.pinLeft(to: leadingAnchor, Constants.leadingIndent)
    }
    
    private func configureStartDatePickerView() {
        addSubview(startDatePickerView)
        
        startDatePickerView.pinTop(to: descriptionTextView.bottomAnchor, Constants.topIndent)
        startDatePickerView.pinCenterX(to: centerXAnchor)
        startDatePickerView.pinLeft(to: leadingAnchor, Constants.leadingIndent)
    }
    
    private func configureEndDatePickerView() {
        addSubview(endDatePickerView)
        
        endDatePickerView.pinTop(to: startDatePickerView.bottomAnchor, Constants.topIndent)
        endDatePickerView.pinCenterX(to: centerXAnchor)
        endDatePickerView.pinLeft(to: leadingAnchor, Constants.leadingIndent)
    }
    
    @objc
    private func closeButtonPressed() {
        delegate?.didCloseButtonPressed()
    }
}

// MARK: - UITextViewDelegate
extension AddWishEventView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Убираем плейсхолдер, если пользователь начинает вводить текст
        switch textView.tag {
        case 1:
            if textView.text == Constants.titleTextViewPlaceholderText {
                textView.text = ""
                textView.textColor = Constants.textViewTextColor // Изменяем цвет текста на основной
                }
        case 2:
            if textView.text == Constants.descriptionTextViewPlaceholderText {
                textView.text = ""
                textView.textColor = Constants.textViewTextColor // Изменяем цвет текста на основной
                }
        default:
            print("no way to reach that code")
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // Возвращаем плейсхолдер, если текстовое поле пустое
        // Убираем плейсхолдер, если пользователь начинает вводить текст
        switch textView.tag {
        case 1:
            if textView.text.isEmpty {
                textView.text = Constants.titleTextViewPlaceholderText
                textView.textColor = Constants.textViewPlaceholderTextColor
            }
        case 2:
            if textView.text.isEmpty {
                textView.text = Constants.descriptionTextViewPlaceholderText
                textView.textColor = Constants.textViewPlaceholderTextColor
            }
        default:
            print("no way to reach that code")
        }
    }
}
