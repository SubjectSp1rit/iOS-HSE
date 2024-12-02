//
//  CoreDataManager.swift
//  aipotiakinPW2
//
//  Created by Arseniy on 02.12.2024.
//

import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    // MARK: - Singleton
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WishModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Ошибка при работе с CoreData: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Ошибка при работе с CoreData: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD Operations
    
    // Добавление нового объекта
    func createObject<T: NSManagedObject>(ofType type: T.Type) -> T {
        return T(context: context)
    }
    
    // Извлечение объектов
    func fetchObjects<T: NSManagedObject>(ofType type: T.Type, with predicate: NSPredicate? = nil, sortedBy sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let request = T.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            return try context.fetch(request) as? [T] ?? []
        } catch {
            print("Ошибка при извлечении объектов из CoreData: \(error)")
            return []
        }
    }
    
    // Удаление объекта
    func deleteObject(_ object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
    
    // Удаление всех объектов определенного типа
    func deleteAllObjects<T: NSManagedObject>(ofType type: T.Type) {
        let fetchRequest = T.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            saveContext()
        } catch {
            print("Ошибка при удалении объектов из CoreData: \(error)")
        }
    }
}
