//
//  WishStoringViewController.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.11.2024.
//

import Foundation
import UIKit

protocol AddElementDelegate: AnyObject {
    func didAddElement(_ element: WishEventModel, _ isSwitchPressed: Bool)
}

final class AddWishEventViewController: UIViewController {
    // MARK: - Constants
    let calendarManager = CalendarEventManager()
    private enum Constants {
        // keys for UserDefaults
        static let wishesKey: String = "wishArray"
        static let wishEventKey: String = "wishEventArray"
        
        // message
        static let endDateGreaterThanStartDateErrorMsg: String = "End date must be greater than start date"
    }
    
    // MARK: - UI Components
    private let addWishEventView = AddWishEventView()
    
    // MARK: - Variables
    weak var delegate: AddElementDelegate?
    var receivedTitle: String?
    var isFromWishStoringViewController: Bool = false
    var onDismiss: (() -> Void)? // Closure for WishStoringViewController
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView(to: addWishEventView)
        addWishEventView.delegate = self
        addWishEventView.configurePickerViewDelegate(self, datasource: self)
        
        if let title = receivedTitle {
            addWishEventView.setDefaultTitleView(to: title)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configurePickerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onDismiss?()
    }
    
    // MARK: - Private Methods
    private func configurePickerView() {
        // Initialize default days (based on the current month)
        let currentDate = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        
        updateDays(forMonthIndex: currentMonth - 1) // Set days for current month
        addWishEventView.configurePickerView(to: currentDate)
    }
    
    private func setView(to otherView: UIView) {
        self.view = otherView
    }
    
    /// Shows error as pop-up
    private func showErrorPopup(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func createDateFromPickerView(_ pickerView: UIPickerView) -> Date {
        // get selected values from pickerViews
        let selectedDay = pickerView.selectedRow(inComponent: 0) + 1
        let selectedMonth = pickerView.selectedRow(inComponent: 1) + 1
        let selectedHour = pickerView.selectedRow(inComponent: 2)
        let selectedMinute = pickerView.selectedRow(inComponent: 3)

        // convert object to Date type
        if let date = createDate(day: selectedDay, month: selectedMonth, year: getCurrentYear(), hour: selectedHour, minute: selectedMinute) {
            return date
        } else {
            fatalError("Error while generating date")
        }
    }
}

extension AddWishEventViewController: AddWishEventViewDelegate {
    func didCloseButtonPressed() {
        dismiss(animated: true)
    }
    
    func didSaveButtonPressed(title: String, description: String, startDatePickerView: UIPickerView, endDatePickerView: UIPickerView, isSwitchPressed: Bool) {
        let startDate: Date = createDateFromPickerView(startDatePickerView)
        let endDate: Date = createDateFromPickerView(endDatePickerView)
        
        if (startDate >= endDate) {
            showErrorPopup(message: Constants.endDateGreaterThanStartDateErrorMsg)
            return
        }
        
        let newWishEvent = WishEventModel(
            title: title,
            description: description,
            startDate: startDate,
            endDate: endDate
        )
        
        // if previous screen if WishStoringViewController - another behaviour
        if (isFromWishStoringViewController) {
            // load arrays to local memory
            var wishEventArray: [WishEventModel] = UserDefaultsManager.shared.load(forKey: Constants.wishEventKey)
            var wishArray: [Wish] = UserDefaultsManager.shared.load(forKey: Constants.wishesKey)
            
            // delete chosen saved wish
            if let index = wishArray.firstIndex(where: { $0.title == title }) {
                wishArray.remove(at: index) }
            
            // add new scheduled wish event
            wishEventArray.append(newWishEvent)
            
            // save all changes to Defaults
            UserDefaultsManager.shared.save(wishEventArray, forKey: Constants.wishEventKey)
            UserDefaultsManager.shared.save(wishArray, forKey: Constants.wishesKey)
            
            if isSwitchPressed {
                calendarManager.create(eventModel: newWishEvent)
            }
        } else {
            delegate?.didAddElement(newWishEvent, isSwitchPressed)
        }
        
        if isSwitchPressed {
            let alert = UIAlertController(title: "Success", message: "The event has been successfully added to the calendar!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    func showError(message: String) {
        showErrorPopup(message: message)
    }
}

// MARK: - UIPickerViewDataSource
extension AddWishEventViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return addWishEventView.days.count // Days
        case 1:
            return addWishEventView.months.count // Months
        case 2:
            return addWishEventView.hours.count // Hours
        case 3:
            return addWishEventView.minutes.count // Minutes
        default:
            return 0
        }
    }
}

// MARK: - UIPickerViewDelegate
extension AddWishEventViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return safeIndex(addWishEventView.days, row) // Days
        case 1:
            return safeIndex(addWishEventView.months, row) // Months
        case 2:
            return safeIndex(addWishEventView.hours, row) // Hours
        case 3:
            return safeIndex(addWishEventView.minutes, row) // Minutes
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            switch component {
            case 0, 2, 3:
                return 50 // Width for days, hours, minutes
            default:
                return 130 // Width for months
            }
    }
    
    // Конвертация данных
    private func createDate(day: Int, month: Int, year: Int, hour: Int, minute: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone.current
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        dateComponents.hour = hour
        dateComponents.minute = minute

        var calendar = Calendar.current
        calendar.timeZone = TimeZone.autoupdatingCurrent

        return calendar.date(from: dateComponents)
    }
    
    // Логика обновления дней
    private func updateDays(forMonthIndex index: Int) {
        let daysInMonth = getDaysInMonth(monthIndex: index, year: getCurrentYear())
        addWishEventView.days = Array(1...daysInMonth).map { "\($0)" }
    }

    private func getDaysInMonth(monthIndex: Int, year: Int) -> Int {
        // Определяем количество дней в месяце
        switch monthIndex {
        case 1: // Февраль
            return isLeapYear(year) ? 29 : 28
        case 3, 5, 8, 10: // Апрель, Июнь, Сентябрь, Ноябрь (30 дней)
            return 30
        default: // Все остальные месяцы (31 день)
            return 31
        }
    }

    private func isLeapYear(_ year: Int) -> Bool {
        // Проверяем, является ли год високосным
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }

    private func getCurrentYear() -> Int {
        // Возвращаем текущий год
        return Calendar.current.component(.year, from: Date())
    }

    // MARK: - Безопасная работа с массивами

    private func safeIndex<T>(_ array: [T], _ index: Int) -> T? {
        guard index >= 0 && index < array.count else {
            return nil
        }
        return array[index]
    }
}
