//
//  Tram.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

struct Tram: Codable {

    // MARK: - Properties
    let destination: String?
    let predictedArrivalTime: String?
    let routeNumber: String?
    
    // MARK: - Keys Enum
    private enum CodingKeys: String, CodingKey {
        case destination = "Destination"
        case predictedArrivalTime = "PredictedArrivalDateTime"
        case routeNumber = "RouteNo"
    }
    
    // MARK: - Methods
    func getCurrentTimeDifference() -> String {
        let dateConverter = DotNetDateConverter()
        var arrivalTimeString = dateConverter.formattedDateFromString(predictedArrivalTime!)
        arrivalTimeString += (" - ETA : " + dateConverter.getTimeDifferenceStringFromCurrentTime(to: predictedArrivalTime!))
        return arrivalTimeString
    }
}
