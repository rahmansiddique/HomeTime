//
//  NetworkConfig.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

var token: Token?
var baseURL = "http://ws3.tramtracker.com.au/TramTracker/RestService"

// MARK: - Protocol to provide string by concatinating base URL
public protocol Directable {
    func directableURL() -> String
}

enum Endpoint: Directable {
    
    // MARK: - Endpoints
    case getApiToken,
    getTrams(token:String, stopId:String)
    
    func directableURL() -> String {
        
        var servicePath = ""
        
        switch (self) {

        case .getApiToken:
            servicePath = "/GetDeviceToken/?aid=TTIOSJSON&devInfo=HomeTimeiOS"
            
        case .getTrams(let token,let stopId):
            servicePath = "/GetNextPredictedRoutesCollection/\(stopId)/78/false/?aid=TTIOSJSON&cid=2&tkn=\(token)"

        }
        return baseURL + servicePath
    }
}
