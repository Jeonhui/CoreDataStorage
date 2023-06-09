//
//  Entitable.swift
//  CoreDataStorage
//
//  Created by 이전희 on 2023/02/12.
//

import CoreData


/// Entitable
/// Struct inherit Entitable
public protocol Entitable {
    var propertyKeys: [String: Any] { get }
    associatedtype EntityType: NSManagedObject, Objectable
    func toEntity(in context: NSManagedObjectContext) -> EntityType
}

public extension Entitable {
    var propertyKeys: [String: Any] {
        let property: [(String, Any)] = Mirror(reflecting: self).children.compactMap { (label: String?, value: Any) in
            guard let label = label else { return nil }
            return (label, value)
        }
        return Dictionary(property, uniquingKeysWith: { (key, _) in key })
    }
}

