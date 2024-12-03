//
//  WishStoringViewController.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.11.2024.
//

import Foundation
import UIKit

final class AddWishEventViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
    }
    
    private let addWishEventView = AddWishEventView()

    
    // MARK: - Variables
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView(to: addWishEventView)
        addWishEventView.delegate = self
        addWishEventView.configurePickerViewDelegate(self, datasource: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configurePickerView()
    }
    
    // MARK: - Private Methods
    private func configurePickerView() {
        // Инициализируем дни по умолчанию (на основе текущего месяца)
        let currentDate = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        
        updateDays(forMonthIndex: currentMonth - 1) // Устанавливаем дни для текущего месяца
        addWishEventView.configurePickerView(to: currentDate)
    }
    
    private func setView(to otherView: UIView) {
        self.view = otherView
    }
}

extension AddWishEventViewController: AddWishEventViewDelegate {
    func didCloseButtonPressed() {
        dismiss(animated: true)
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
            return addWishEventView.days.count // Дни
        case 1:
            return addWishEventView.months.count // Месяцы
        case 2:
            return addWishEventView.hours.count // Часы
        case 3:
            return addWishEventView.minutes.count // Минуты
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
            return safeIndex(addWishEventView.days, row) // Дни
        case 1:
            return safeIndex(addWishEventView.months, row) // Месяцы
        case 2:
            return safeIndex(addWishEventView.hours, row) // Часы
        case 3:
            return safeIndex(addWishEventView.minutes, row) // Минуты
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 1:
            updateDays(forMonthIndex: pickerView.selectedRow(inComponent: 1))
            pickerView.reloadComponent(0) // Перезагружаем колонку с днями
        default:
            break
        }

        // Получаем выбранные значения
        let selectedDay = pickerView.selectedRow(inComponent: 0) + 1
        let selectedMonth = pickerView.selectedRow(inComponent: 1) + 1
        let selectedHour = pickerView.selectedRow(inComponent: 2)
        let selectedMinute = pickerView.selectedRow(inComponent: 3)

        // Преобразуем в объект Date
        if let date = createDate(day: selectedDay, month: selectedMonth, year: getCurrentYear(), hour: selectedHour, minute: selectedMinute) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone.current
            print("Выбрано: \(formatter.string(from: date))")
        } else {
            print("Некорректная дата")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            switch component {
            case 0:
                return 30
            case 2, 3:
                return 50 // Ширина колонок для часов и минут
            default:
                return 120 // Ширина для остальных колонок
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

        // Устанавливаем временную зону на текущую
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.autoupdatingCurrent // Используем текущую временную зону

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
