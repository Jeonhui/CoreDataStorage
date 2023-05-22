//
//  Movie.swift
//  CoreDataStorage_Example
//
//  Created by 이전희 on 2023/05/15.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import CoreData
import CoreDataStorage

// Example Struct
struct Movie {
    let id: String
    let title: String
    let releaseDate: Date
    let desc: String
}

// Struct connect Entity
extension Movie: Entitable {
    func toEntity(in context: NSManagedObjectContext) -> MovieEntity {
        let entity: MovieEntity = .init(context: context)
        entity.id = id
        entity.title = title
        entity.releaseDate = releaseDate
        entity.desc = desc
        return entity
    }
}

// Entity connect Struct
extension MovieEntity: Objectable {
    public func toObject() -> some Entitable {
        return Movie(id: id ?? UUID().uuidString,
                         title: title ?? "unknown",
                         releaseDate: releaseDate ?? Date(),
                         desc: desc ?? "")
    }
}
