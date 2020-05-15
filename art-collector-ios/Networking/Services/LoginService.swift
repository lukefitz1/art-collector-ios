//
//  LoginService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/27/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct LoginService {
    
    func login(username: String, password: String, completionHandler: ((Bool?, String?) -> Void)?) {
        let endpoint = buildEndpoint()
        
        let parameters = [
            "email": username,
            "password": password
        ]
        
        AF.request(endpoint,
                   method: .post,
                   parameters: parameters,
                   encoder: URLEncodedFormParameterEncoder.default).responseJSON { response in
                    
                    switch response.response?.statusCode {
                    case 200:
                        if let safeResponse = response.response {
                            let parsedHeaders = self.parseHeaders(response: safeResponse)
                            completionHandler?(parsedHeaders, nil)
                        } else {
                            completionHandler?(nil, nil)
                        }
                    default:
                        completionHandler?(nil, response.response?.description)
                    }
        }
    }
    func parseHeaders(response: HTTPURLResponse) -> Bool {
        let headers = response.allHeaderFields
        headers.forEach { (keyVals) in
            let (key, value) = keyVals
            let keyString = key as! String //dict["message"] as String
            
            if keyString == "Access-Token" || keyString == "access-token" {
                ApiClient.accessToken = value as! String
            } else if keyString == "Client" || keyString == "client" {
                ApiClient.client = value as! String
            } else if keyString == "Uid" || keyString == "uid"  {
                ApiClient.uid = value as! String
            } else if keyString == "Expiry" || keyString == "expiry"  {
                ApiClient.expiry = value as! String
            } else if keyString == "Token-Type" || keyString == "token-type"  {
                ApiClient.tokenType = value as! String
            }
        }
        
        return true
    }
    
    private func buildEndpoint() -> URL {
        return URL(string: "\(ApiClient.baseUrl)auth/sign_in")!
    }
}

struct LoginData: Decodable {
    let auth_token: String
}

struct Login: Encodable {
    let email: String
    let password: String
}
