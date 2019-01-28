//
//  TramsLoader.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

class TramsLoader{
    
    // MARK: - Properties
    private let manager = ServiceManager.shared
    
    // MARK: - Methods
    func loadTrams(stopID:String, completion: @escaping (_ responseData: [Tram]?, _ error: Error?) -> Void){
        //Get pre-fetched token here
        let token = DataManager.shared.getToken()
        let endpoint = Endpoint.getTrams(token: token, stopId: stopID).directableURL()
        manager.makeSimpleRequest(url: endpoint, success: { (response:[Any]) in
            //Tram goes here
            do {
                var trams = [Tram]()
                for tramDict in response{
                    let tramObj = try Tram(from: tramDict)
                    trams.append(tramObj)
                }
                completion(trams, nil)
            }catch {
                completion(nil, NSError(domain: "Parsing Error", code: 152, userInfo: nil) as Error)
            }

            }) { (error) in
                //Error goes here
                completion(nil,error)
        }
    }
    
}
