//
//  GetCustomerService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/9/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct GetCustomerService {
    var deserializer: GetCustomerServiceDeserializerProtocol
    
    init(deserializer: GetCustomerServiceDeserializerProtocol = GetCustomerServiceDeserializer()) {
        self.deserializer = deserializer
    }
    
    func getCustomer(completionHandler: ((Customer?, Error?) -> Void)?) {
        let endpoint = buildEndpoint()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiClient.authToken)"
        ]
        
        var data : Customer?
        
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
    
    func parseJSON(customerData: Data) -> Customer? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(Customer.self, from: customerData)
            return decodedData
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    private func buildEndpoint() -> URL {
        let customerId = "866ad16d-ace2-4e3f-aa07-db973863e9a6"
        return URL(string: "\(ApiClient.baseUrl)customer/\(customerId)")!
    }
}
