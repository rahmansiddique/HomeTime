//
//  DataManager.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation


class DataManager {
    
    // MARK: - Properties
    static let shared = DataManager.init()
    private let standardDefaults = UserDefaults.standard

    // MARK: - Initializer
    private init(){}

    // MARK: - Methods
    func saveTokenLocally(token:String) {
        standardDefaults.set(token, forKey: keyToken)
        standardDefaults.synchronize()
    }
    
    func getToken()->String{return standardDefaults.string(forKey: keyToken) ?? ""}
}
