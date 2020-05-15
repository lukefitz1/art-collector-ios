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
//                        if let safeData = response.data {
//                            let token = self.parseJSON(loginData: safeData)
//                            completionHandler?(token, nil)
//                        } else {
//                            completionHandler?(nil, nil)
//                        }
                    default:
                        completionHandler?(nil, response.response?.description)
                    }
        }
    }
    // -> [String: Any]
    func parseHeaders(response: HTTPURLResponse) -> Bool {
        let headers = response.allHeaderFields
        headers.forEach { (keyVals) in
            let (key, value) = keyVals
            let keyString = key as! String //dict["message"] as String
            
            if keyString == "Access-Token" || keyString == "access-token" {
                print("Key found! \(keyString)")
                print("Value: \(value)")
                ApiClient.accessToken = value as! String
            } else if keyString == "Client" || keyString == "client" {
                print("Key found! \(keyString)")
                print("Value: \(value)")
                ApiClient.client = value as! String
            } else if keyString == "Uid" || keyString == "uid"  {
                print("Key found! \(keyString)")
                print("Value: \(value)")
                ApiClient.uid = value as! String
            } else if keyString == "Expiry" || keyString == "expiry"  {
                print("Key found! \(keyString)")
                print("Value: \(value)")
                ApiClient.expiry = value as! String
            } else if keyString == "Token-Type" || keyString == "token-type"  {
                print("Key found! \(keyString)")
                print("Value: \(value)")
                ApiClient.tokenType = value as! String
            }
        }
        
        return true
    }
    
//    func parseJSON(loginData: Data) -> String {
//        let decoder = JSONDecoder()
//
//        do {
//            let decodedData = try decoder.decode(LoginData.self, from: loginData)
//            let authToken = decodedData.auth_token
//            ApiClient.authToken = authToken
//
//            return authToken
//        } catch  {
//            print(error)
//        }
//
//        return ""
//    }
    
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
