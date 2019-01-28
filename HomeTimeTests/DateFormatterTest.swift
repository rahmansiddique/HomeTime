//
//  Copyright (c) 2015 REA. All rights reserved.
//

import UIKit
import Nimble
import Quick
@testable import HomeTime

class DateFormatTest: QuickSpec {
    
    // MARK: - Methods Overridden
    override func spec() {
        var mockTram:Tram?
        let converter = DotNetDateConverter()
        
        beforeEach {
            mockTram = Tram(destination: "Lahore", predictedArrivalTime: "/Date(1426821588000+1100)/", routeNumber: "85")
        }
        
        // MARK: - Correct time string test
        it("should correctly convert the date string stored in tram") {
            let date = converter.formattedDateFromString((mockTram?.predictedArrivalTime)!)
            expect(date) == "08:19"
        }
        // MARK: - Date object and value test
        it ("should return the date object with correct time interval with reference to the base value"){
            let date = converter.dateFromDotNetFormattedDateString((mockTram?.predictedArrivalTime)!)
            expect(date).toEventually(beAnInstanceOf(Date.self))
            expect(date?.timeIntervalSinceReferenceDate) == 448514388.0
        }
        // MARK: - Time differnce string test
        it ("should return the time diffence correctly with reference to 20 Mins ahead from tram time"){
            let timeIntervalSinceRef = converter.dateFromDotNetFormattedDateString((mockTram?.predictedArrivalTime)!)?.timeIntervalSinceReferenceDate
            let mockTime = Date(timeIntervalSinceReferenceDate: timeIntervalSinceRef!).subtracting(minutes: 20)
            let date = converter.getTimeDifferenceStringFromRefernceTime(to: (mockTram?.predictedArrivalTime)!, fromDate:mockTime )
            expect(date) == "20 Mins"
        }
        
    }
    
}
