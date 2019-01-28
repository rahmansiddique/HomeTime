//
//  TokenLoader.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation

class TokenLoader{

    // MARK: - Properties
    private let manager = ServiceManager.shared
    
    // MARK: - Methods
    func loadToken(completion: @escaping (_ responseData: String?, _ error: Error?) -> Void){
        let endpoint = Endpoint.getApiToken.directableURL()
        
        manager.makeSimpleRequest(url: endpoint, success: { (token) in
            for tokenDict in token{
                do{
                    let tokenObj = try Token(from: tokenDict)
                    completion(tokenObj.token, nil)
                    break
                }catch {
                    completion("", NSError(domain: "Parsing Error", code: 152, userInfo: nil) as Error)
                }
            }
        }) { (error) in
            completion("", error)
        }
    }
}
