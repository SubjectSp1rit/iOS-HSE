//
//  UserDefaultsManager.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 12/2/24.
//

import Foundation
import UIKit

/// Singleton-класс для управления UserDefaults
final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults: UserDefaults

    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func save(_ wishes: [Wish], forKey key: String) {
        do {
            let data = try JSONEncoder().encode(wishes)
            defaults.set(data, forKey: key)
        } catch {
            fatalError("Ошибка при сохранении данных в UserDefaults")
        }
    }
    
    func load(forKey key: String) -> [Wish] {
        guard let data = defaults.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([Wish].self, from: data)
        } catch {
            fatalError("Ошибка при загрузке данных из UserDefaults")
        }
    }
}
