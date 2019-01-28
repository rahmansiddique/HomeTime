//
//  Token.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

struct Token: Codable {
    
    // MARK: - Properties
    let token: String?
    
    // MARK: - Keys Enum
    private enum CodingKeys: String, CodingKey {
        case token = "DeviceToken"
    }
}
