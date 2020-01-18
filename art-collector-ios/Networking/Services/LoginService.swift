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
//    let apiClient: ApiClient
//
//    init() {
//         self.apiClient = ApiClient()
//    }
    
    func login(username: String, password: String, completionHandler: ((LoginData?, Error?) -> Void)?) {
        let endpoint = buildEndpoint()
        
        let parameters = [
            "user_login[email]": username,
            "user_login[password]": password
        ]
        
        AF.request(endpoint,
                   method: .post,
                   parameters: parameters,
                   encoder: URLEncodedFormParameterEncoder.default).responseJSON { response in
//             debugPrint(response)
                    
                    switch response.result {
                        case .success:
//                            print("Validation Successful")
                            
                            if let safeData = response.data {
                                self.parseJSON(loginData: safeData)
                            }
                            completionHandler?(nil, nil)
                        case let .failure(error):
                            print(error)
                            completionHandler?(nil, error)
                    }
        }
    }
    
    func parseJSON(loginData: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(LoginData.self, from: loginData)
            let authToken = decodedData.auth_token
            
//            print(authToken)
            ApiClient.authToken = authToken
//            print("Test \(ApiClient.authToken)")
//            return decodedData
        } catch  {
            print(error)
        }
    }
    
    private func buildEndpoint() -> URL {
        return URL(string: "\(ApiClient.baseUrl)sign-in")!
    }
    
//    private func buildParameters(username: String, password: String) -> Parameters {
//        return serializer.serialize(username: username, password: password)
//    }
}

struct LoginData: Decodable {
    let auth_token: String
}

struct Login: Encodable {
    let email: String
    let password: String
}

struct LoginInfo {
    // MARK: - Public methods
    
    func serialize(username: String, password: String) -> Parameters {
        let parameters: Parameters = ["user_login[email]": username,
                                      "user_login[password]": password]
        
        return parameters
    }
}
