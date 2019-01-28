//
//  ServiceManager.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

enum JSONError: Error {
    case serialization
}

class ServiceManager {
    
    // MARK: - Aliases
    typealias SuccessBlock = (_ response: [Any]) -> Void
    typealias FailureBlock = (_ error: Error) -> Void

    // MARK: - Properties
    static let shared = ServiceManager.init()
    var session: URLSession!
    
    // MARK: - Initializer
    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    // MARK: - Methods
    func makeSimpleRequest(url: String, success: @escaping SuccessBlock, failure: @escaping FailureBlock ) {
        guard let url = URL(string: url) else {return}
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                failure(error!)
            } else {
                do {
                    if let data = data,
                        let jsonResp = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSONDictionary {
                        let objects = jsonResp["responseObject"]
                        guard let objectArray = objects as? [Any] else {
                            failure(JSONError.serialization)
                            return
                        }
                        success(objectArray)
                        
                    } else {
                        failure(JSONError.serialization)
                    }
                } catch {
                    failure(JSONError.serialization)
                }
            }
        })
        task.resume()
    }
}

