//
//  CoreDataStorageDetailError.swift
//  CoreDataStorage
//
//  Created by 이전희 on 2023/02/12.
//

import Foundation

public enum CoreDataStorageDetailError {
    case couldNotFindDataError
    case castError
    case wrongConnectError
}

extension CoreDataStorageDetailError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .couldNotFindDataError:
            return NSLocalizedString("couldNotFindDataError", comment: "Couldn't find data")
        case .castError:
            return NSLocalizedString("castError", comment: "Couldn't cast type")
        case .wrongConnectError:
            return NSLocalizedString("wrongConnectError", comment: "Wrong Connect Error, check Entitable or Objectable")
        }
    }
}
