//
//  Objectable.swift
//  CoreDataStorage
//
//  Created by 이전희 on 2023/02/12.
//

import Foundation

/// Objectable
/// NSManagedObejct inherit Objectable
public protocol Objectable {
    associatedtype ObjectType: Entitable
    func toObject() -> ObjectType
}

