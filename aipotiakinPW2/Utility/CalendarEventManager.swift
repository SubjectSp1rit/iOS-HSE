//
//  CalendarEventManager.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 03.12.2024.
//

import Foundation
import EventKit

final class CalendarEventManager: CalendarManaging {
    private let eventStore: EKEventStore = EKEventStore()
    
    @discardableResult
    func create(eventModel: WishEventModel) -> Bool {
        var result: Bool = false
        let group = DispatchGroup()
        group.enter()
        
        create(eventModel: eventModel) { isCreated in
            result = isCreated
            group.leave()
        }
        
        group.wait()
        
        return result
    }
    
    func create(eventModel: WishEventModel, completion: ((Bool) -> Void)?) {
        let createEvent: EKEventStoreRequestAccessCompletionHandler = { [weak self] (granted, error) in
            guard granted, error == nil, let self else {
                completion?(false)
                return
            }
            
            let event: EKEvent = EKEvent(eventStore: self.eventStore)
            
            event.title = eventModel.title
            event.notes = eventModel.description
            event.startDate = eventModel.startDate
            event.endDate = eventModel.endDate
            event.calendar = self.eventStore.defaultCalendarForNewEvents
            
            do {
                try self.eventStore.save(event, span: .thisEvent)
            } catch let error as NSError {
                print("failed to save event with error: \(error)")
                completion?(false)
            }
            
            completion?(true)
        }
        
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: createEvent)
        } else {
            eventStore.requestAccess(to: .event, completion: createEvent)
        }
    }
}
