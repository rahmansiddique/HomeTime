//
//  Date + Additions.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

extension Date {
    func subtracting(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: -minutes, to: self)!
    }
}
