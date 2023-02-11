//
//  CoreDataStorageError.swift
//  CoreDataStorage
//
//  Created by 이전희 on 2023/02/12.
//

import Foundation

public enum CoreDataStorageError: Error {
    case createError(Error)
    case readError(Error)
    case updateError(Error)
    case deleteError(Error)
}

