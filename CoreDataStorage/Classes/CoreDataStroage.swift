//
//  CoreDataStorage.swift
//  CoreDataStorage
//
//  Created by 이전희 on 2023/02/12.
//

import Foundation
import CoreData
import Combine

open class CoreDataStorage {
    // Created CoreDataStorages
    static private var storages: [String: CoreDataStorage] = [:]
    
    // Default CoreDataStorage
    static let `default`: CoreDataStorage = CoreDataStorage(name: "CoreDataStorage")
    
    // Custom CoreDataStorage with Name
    static func shared(name: String = "CoreDataStorage") -> CoreDataStorage {
        guard let storage = storages[name] else {
            return CoreDataStorage(name: name)
        }
        return storage
    }
    
    private init(name: String) {
        persistentContainerName = name
        CoreDataStorage.storages[name] = self
    }
    
    private let persistentContainerName: String
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // manual Save Context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Unresolved error \(error), \(error)")
            }
        }
    }
}

extension CoreDataStorage {
    /// Create
    /// - Parameter value: Struct: Entitable
    /// - Returns: created Entity into Struct
    func create<O>(_ value: O) -> AnyPublisher<O, Error>
    where O: Entitable {
        Future<O, Error> { promise in
            self.persistentContainer.performBackgroundTask { context in
                _ = value.toEntity(in: context)
                do {
                    try context.save()
                    promise(.success(value))
                } catch {
                    promise(.failure(CoreDataStorageError.createError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Read
    /// - Parameters:
    ///   - type: Struct: Entitable Type to Read
    ///   - predicate: predicate
    ///   - sortDescriptors: Sort Descripctors
    /// - Returns: read All Entities into Structures
    func read<O: Entitable>(type: O.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> AnyPublisher<[O], Error> {
        Future<[O], Error> { promise in
            self.persistentContainer.performBackgroundTask { context in
                do {
                    let request: NSFetchRequest = O.EntityType.fetchRequest()
                    request.predicate = predicate
                    request.sortDescriptors = sortDescriptors
                    guard let result = try context.fetch(request).compactMap({ ($0 as? O.EntityType)?.toObject() }) as? [O] else {
                        throw CoreDataStorageDetailError.wrongConnectError
                    }
                    promise(.success(result))
                } catch {
                    promise(.failure(CoreDataStorageError.readError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Update
    /// - Parameters:
    ///   - updateObject: updated Structure: Entitable
    ///   - predicate: predicate
    ///   - limit: umber of entities to update
    /// - Returns: updated Entities into Structures
    /// If result is empty, Create update Object.
    func update<O: Entitable>(_ updateObject: O, predicate: NSPredicate, limit: Int? = nil) -> AnyPublisher<[O], Error> {
        Future<[O], Error> { promise in
            self.persistentContainer.performBackgroundTask { context in
                let request: NSFetchRequest = O.EntityType.fetchRequest()
                request.predicate = predicate
                do {
                    let fetchEntities = try context.fetch(request)
                    if fetchEntities.isEmpty {
                        _ = updateObject.toEntity(in: context)
                        do {
                            try context.save()
                            promise(.success([updateObject]))
                        } catch {
                            promise(.failure(CoreDataStorageError.createError(error)))
                        }
                        return
                    }
                    if let entities = fetchEntities as? [O.EntityType] {
                        let limit = min(entities.count, limit ?? 1)
                        entities[0..<limit].forEach { entity in
                            updateObject.propertyKeys.forEach { (key: String, value: Any) in
                                entity.setValue(value, forKey: key)
                            }
                        }
                        try context.save()
                        guard let result = entities.map({ $0.toObject() }) as? [O] else {
                            throw CoreDataStorageDetailError.wrongConnectError
                        }
                        promise(.success(result))
                    } else {
                        throw CoreDataStorageDetailError.castError
                    }
                } catch {
                    promise(.failure(CoreDataStorageError.updateError(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Update(values)
    /// - Parameters:
    ///   - type: Struct: Entitable Type to Update
    ///   - updateValues: update Values
    ///   - predicate: predicate
    /// - Returns: predicated Entities to Structures
    func update<O: Entitable>(_ type: O.Type, updateValues: [String: Any], predicate: NSPredicate) -> AnyPublisher<[O], Error> {
        Future<[O], Error> { promise in
            self.persistentContainer.performBackgroundTask { context in
                let request: NSFetchRequest = O.EntityType.fetchRequest()
                request.predicate = predicate
                do {
                    let fetchEntities = try context.fetch(request)
                    if fetchEntities.isEmpty {
                        promise(.success([]))
                        return
                    }
                    
                    if let entities = fetchEntities as? [O.EntityType] {
                        entities.forEach { entity in
                            updateValues.forEach { (key: String, value: Any) in
                                entity.setValue(value, forKey: key)
                            }
                        }
                        try context.save()
                        guard let result = entities.map({ $0.toObject() }) as? [O] else {
                            throw CoreDataStorageDetailError.wrongConnectError
                        }
                        promise(.success(result))
                    }  else {
                        throw CoreDataStorageDetailError.castError
                    }
                } catch {
                    promise(.failure(CoreDataStorageError.updateError(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Delete
    /// - Parameters:
    ///   - type: Struct: Entitable Type to Delete
    ///   - predicate: predicate
    /// - Returns: Deleted Entities into Structures
    func delete<O: Entitable>(_ type: O.Type, predicate: NSPredicate, limit: Int? = nil) -> AnyPublisher<[O], Error> {
        Future<[O], Error> { promise in
            self.persistentContainer.performBackgroundTask { context in
                let request: NSFetchRequest = O.EntityType.fetchRequest()
                request.predicate = predicate
                do {
                    let fetchEntities = try context.fetch(request)
                    if let entities = fetchEntities as? [O.EntityType] {
                        let limit = min(entities.count, limit ?? 1)
                        entities[0..<limit].forEach { entity in
                            context.delete(entity as NSManagedObject)
                        }
                        try context.save()
                        guard let result = entities.map({ $0.toObject() }) as? [O] else {
                            throw CoreDataStorageDetailError.wrongConnectError
                        }
                        promise(.success(result))
                    } else {
                        throw CoreDataStorageDetailError.couldNotFindDataError
                    }
                } catch {
                    promise(.failure(CoreDataStorageError.updateError(error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// DeleteAll
    /// - Parameter type: Struct: Entitable Type to Delete
    /// - Returns: Success or Fail
    func deleteAll<O: Entitable>(_ type: O.Type) -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { promise in
            self.persistentContainer.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest = O.EntityType.fetchRequest()
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                batchDeleteRequest.resultType = .resultTypeObjectIDs
                do {
                    guard let _ = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult else {
                        throw CoreDataStorageDetailError.castError
                    }
                    try context.save()
                    promise(.success(true))
                } catch {
                    promise(.failure(CoreDataStorageError.deleteError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
