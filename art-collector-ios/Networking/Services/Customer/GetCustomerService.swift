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
    
    func getCustomer(customerId: String, completionHandler: ((Customer?, Error?) -> Void)?) {
        let endpoint = buildEndpoint(customerId: customerId)
        let headers: HTTPHeaders = [
            "access-token": ApiClient.accessToken,
            "client": ApiClient.client,
            "uid": ApiClient.uid,
            "expiry": ApiClient.expiry,
            "token-type": ApiClient.tokenType
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
    
    private func buildEndpoint(customerId: String) -> URL {
        return URL(string: "\(ApiClient.baseUrl)customer/\(customerId)")!
    }
}
