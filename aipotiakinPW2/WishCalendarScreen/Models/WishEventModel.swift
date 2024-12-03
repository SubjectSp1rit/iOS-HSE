//
//  WishEventModel.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.12.2024.
//

protocol CalendarManaging {
    func create(eventModel: WishEventModel) -> Bool
}

import Foundation

struct WishEventModel: Codable {
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
}
