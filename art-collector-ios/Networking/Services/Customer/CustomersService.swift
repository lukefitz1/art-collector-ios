//
//  CustomersService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/27/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct CustomersService {
    var deserializer: CustomersServiceDeserializerProtocol
    
    init(deserializer: CustomersServiceDeserializerProtocol = CustomersServiceDeserializer()) {
        self.deserializer = deserializer
    }
    
    func getCustomers(completionHandler: (([Customer]?, Error?) -> Void)?) {
        let endpoint = buildEndpoint()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiClient.authToken)"
        ]
        var data : [Customer] = []
        
        AF.request(endpoint,
                   headers: headers).responseJSON { responseJSON in
                    switch responseJSON.result {
                        case .success:
                            if let safeData = responseJSON.data {
                                data = self.parseJSON(customerData: safeData)
                            }
                            
                            completionHandler?(data, nil)
                        case let .failure(error):
                            print(error)
                            completionHandler?(nil, error)
                    }
        }
    }
    
    func parseJSON(customerData: Data) -> [Customer] {
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode([Customer].self, from: customerData)
                return decodedData
            } catch  {
                print(error)
            }
        
            return []
        }
    
    private func buildEndpoint() -> URL {
        return URL(string: "\(ApiClient.baseUrl)customer")!
    }
}
