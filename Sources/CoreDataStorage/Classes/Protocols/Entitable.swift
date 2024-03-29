//
//  Entitable.swift
//  CoreDataStorage
//
//  Created by 이전희 on 2023/02/12.
//

import CoreData


/// Entitable
/// Struct must inherit Entitable
public protocol Entitable {
    var propertyKeyValues: [String: Any] { get }
    associatedtype EntityType: NSManagedObject, Objectable
    func toEntity(in context: NSManagedObjectContext) -> EntityType
}

public extension Entitable {
    var propertyKeyValues: [String: Any] {
        let property: [(String, Any)] = Mirror(reflecting: self).children.compactMap { (label: String?, value: Any) in
            guard let label = label else { return nil }
            return (label, value)
        }
        return Dictionary(property, uniquingKeysWith: { (key, _) in key })
    }
}

