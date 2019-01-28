//
//  Copyright © 2017 REA. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import HomeTime

class ViewControllerSpec: QuickSpec {
    
    override func spec() {
        describe("ViewController") {
            var viewController: ViewController?
            
            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                viewController = storyboard.instantiateViewController(withIdentifier: "viewController") as? ViewController
                _ = viewController?.view
            }
            // MARK: - Table secion count test
            it("should have sections for north and south") {
                let sections = viewController?.tramTimesTable.numberOfSections
                expect(sections) == 2
            }
            // MARK: - No data test
            it("should initialize no tram data") {
                let tramsTable = viewController?.tramTimesTable
                
                let north = tramsTable?.numberOfRows(inSection: 0)
                expect(north) == 1
                
                let placeholderCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 0)) as! TramsNotFoundTVC
                placeholderCell.configCell(message: "No upcoming trams")
                let placeholder = placeholderCell.messageLabel.text
                expect(placeholder?.hasPrefix("No upcoming trams")) == true
                
                let south = tramsTable?.numberOfRows(inSection: 1)
                expect(south) == 1
            }
            // MARK: - With data test
            it("should display arriveDateTime on table after load api response") {
                let tramsTable = viewController?.tramTimesTable
                
                let northTramExp = expect(viewController?.northTrams)
                let southTramExp = expect(viewController?.southTrams)
                
                northTramExp.toNotEventually(haveCount(0), timeout: 10.0, pollInterval: 0.5, description: "North Trams Not Loaded")
                southTramExp.toNotEventually(haveCount(0), timeout: 10.0, pollInterval: 0.5, description: "South Trams Not Loaded")
                
                let northTramCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 0)) as! TramDetailTVC
                expect(northTramCell.destinationLabel.text) == "North Richmond"
                
                let southTramCell = tramsTable?.cellForRow(at: IndexPath(row: 0, section: 1)) as! TramDetailTVC
                expect(southTramCell.destinationLabel.text) == "Balaclava"
                
                expect(viewController?.tramTimesTable.numberOfRows(inSection: 0)) == viewController?.northTrams?.count
                expect(viewController?.tramTimesTable.numberOfRows(inSection: 1)) == viewController?.southTrams?.count
            }
            // MARK: - clear button tap test
            it("should clear out the data and tableview should only have one placeholder cell"){
                UIApplication.shared.sendAction((viewController?.clearButton.action)!, to: viewController?.clearButton.target, from: self, for: nil)
                let tramsTable = viewController?.tramTimesTable
                expect(tramsTable?.numberOfRows(inSection: 0)) == 1
                expect(tramsTable?.numberOfRows(inSection: 1)) == 1
            }
            // MARK: - reload button tap test
            it("should reload the data and tableview should only have multiple tram cell"){
                UIApplication.shared.sendAction((viewController?.loadButton.action)!, to: viewController?.loadButton.target, from: self, for: nil)
                
                let northTramExp = expect(viewController?.northTrams)
                let southTramExp = expect(viewController?.southTrams)
                
                northTramExp.toNotEventually(haveCount(0), timeout: 10.0, pollInterval: 0.5, description: "North Trams Not Loaded")
                southTramExp.toNotEventually(haveCount(0), timeout: 10.0, pollInterval: 0.5, description: "South Trams Not Loaded")
                
                let tramsTable = viewController?.tramTimesTable
                expect(tramsTable?.numberOfRows(inSection: 0)) == viewController?.northTrams?.count
                expect(tramsTable?.numberOfRows(inSection: 1)) == viewController?.southTrams?.count
            }
        }
    }
}
