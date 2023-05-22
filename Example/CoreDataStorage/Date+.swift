//
//  Date+.swift
//  CoreDataStorage_Example
//
//  Created by 이전희 on 2023/05/21.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

extension Date{
    func toDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
