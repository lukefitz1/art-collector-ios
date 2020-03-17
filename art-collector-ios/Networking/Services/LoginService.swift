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
    
    func login(username: String, password: String, completionHandler: ((String?, String?) -> Void)?) {
        let endpoint = buildEndpoint()
        
        let parameters = [
            "user_login[email]": username,
            "user_login[password]": password
        ]
        
        AF.request(endpoint,
                   method: .post,
                   parameters: parameters,
                   encoder: URLEncodedFormParameterEncoder.default).responseJSON { response in
                    
                    switch response.response?.statusCode {
                    case 200:
                        if let safeData = response.data {
                            let token = self.parseJSON(loginData: safeData)
                            completionHandler?(token, nil)
                        } else {
                            completionHandler?(nil, nil)
                        }
                    default:
                        completionHandler?(nil, response.response?.description)
                    }
        }
    }
    
    func parseJSON(loginData: Data) -> String {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(LoginData.self, from: loginData)
            let authToken = decodedData.auth_token
            ApiClient.authToken = authToken
            
            return authToken
        } catch  {
            print(error)
        }
        
        return ""
    }
    
    private func buildEndpoint() -> URL {
        return URL(string: "\(ApiClient.baseUrl)sign-in")!
    }
}

struct LoginData: Decodable {
    let auth_token: String
}

struct Login: Encodable {
    let email: String
    let password: String
}
