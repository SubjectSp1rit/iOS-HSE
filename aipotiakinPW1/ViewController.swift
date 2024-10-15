//
//  ViewController.swift
//  aipotiakinPW1
//
//  Created by Arseniy on 15.10.2024.
//

import UIKit

final class ViewController: UIViewController {
    // MARK: ~ Variables
    @IBOutlet weak var button: UIButton!
    @IBOutlet var viewList: [UIView]!
    
    @IBOutlet var views: [UIView]!
    
    // MARK: ~ Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var colorsSet = getUniqueColors(for: self.viewList.count)
        var shapesList = getShapes(for: self.viewList.count)
        
        for view in self.viewList {
            let firstColorInSet = colorsSet.popFirst()
            let color = UIColor(hex: firstColorInSet!)
            let shape = shapesList.popLast()
            view.backgroundColor = color
            view.layer.cornerRadius = CGFloat(shape!)
        }
    }
    
    // MARK: ~ Methods
    @IBAction func buttonWasPressed(_ sender: UIButton) {
        sender.isEnabled = false
        
        var colorsSet = getUniqueColors(for: self.viewList.count)
        var shapesList = getShapes(for: self.viewList.count)
        UIView.animate(withDuration: 1,
           animations: {
            for view in self.viewList {
                let firstColorInSet = colorsSet.popFirst()
                let color = UIColor(hex: firstColorInSet!)
                let shape = shapesList.popLast()
                view.backgroundColor = color
                view.layer.cornerRadius = CGFloat(shape!)
            }
        }, completion: { [weak self] _ in self?.button.isEnabled = true })
    }
    
    func getUniqueColors(for viewCount: Int) -> Set<String> {
        var set = Set<String>()
        while set.count < viewCount {
            set.insert(generateRandomHexNumber())
        }
        return set
    }
    
    func getShapes(for viewCount: Int) -> [Int] {
        var arr = Array<Int>()
        for _ in 0..<viewCount {
            let minCornerRadius = 0
            let maxCornerRadius = 30
            arr.append(Int.random(in: minCornerRadius...maxCornerRadius))
        }
        return arr
    }
    
    func generateRandomHexNumber() -> String {
        let hexValues = "0123456789ABCDEF"
        var result = "#"
        
        let hexLength = 6
        for _ in 0..<hexLength {
            let randomIndex = Int.random(in: 0..<hexValues.count)
            let randomCharacter = hexValues[hexValues.index(hexValues.startIndex, offsetBy: randomIndex)]
            result.append(randomCharacter)
        }
        
        return result
    }
}

// MARK: ~ Extensions
extension UIColor {
    convenience init(hex: String) {
        // Убираем пробелы и \n, делаем строку заглавной
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // По стандарту HEX имеет # в начале, - убираем
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgb: UInt64 = 0
        // Преобразуем HEX-строку в число
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        // Извлекаем компоненты красного, зеленого и синего из числа
        // & (побитовое и) “вытаскивает” FF символы, которые представляют цвета
        // Далее цвет сдвигается на 16/8/0 битов вправо, чтобы получить значение в диапазоне 0...255
        let dividerToRgb = 255.0
        let red = CGFloat((rgb & 0xFF0000) >> 16) / dividerToRgb
        let green = CGFloat((rgb & 0x00FF00) >> 8) / dividerToRgb
        let blue = CGFloat(rgb & 0x0000FF) / dividerToRgb
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
