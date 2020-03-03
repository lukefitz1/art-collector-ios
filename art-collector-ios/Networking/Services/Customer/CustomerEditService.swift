//
//  CustomerEditService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/2/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct CustomerEditService {
    
    let serializer: CustomerCreateServiceSerializerProtocol
    let deserializer: CustomerCreateServiceDeserializerProtocol
    
    init(deserializer: CustomerCreateServiceDeserializerProtocol = CustomerCreateServiceDeserializer(),
         serializer: CustomerCreateServiceSerializerProtocol = CustomerCreateServiceSerializer()) {
        self.deserializer = deserializer
        self.serializer = serializer
    }
    
    func updateCustomer(id: String,
                        fName: String,
                        lName: String,
                        email: String,
                        phone: String,
                        address: String,
                        city: String,
                        state: String,
                        zip: String,
                        referredBy: String,
                        projectNotes: String,
                        completionHandler: ((Customer?, Error?) -> Void)?) {
        
        let fullEndpoint = buildEndpoint(customerId: id)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiClient.authToken)"
        ]
        
        let parameters = buildParameters(firstName: fName, lastName: lName, email: email, phone: phone, street: address, city: city, state: state, zip: zip, referredBy: referredBy, projectNotes: projectNotes)
        
        var data : Customer?
        
        AF.request(fullEndpoint,
                   method: .put,
                   parameters: parameters,
                   encoding: JSONEncoding(),
                   headers: headers).responseJSON { responseJSON in
//                     debugPrint(responseJSON)
                    
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
    
    private func buildParameters(firstName: String,
                                 lastName: String,
                                 email: String,
                                 phone: String,
                                 street: String,
                                 city: String,
                                 state: String,
                                 zip: String,
                                 referredBy: String,
                                 projectNotes: String) -> Parameters {
        
        let parameters = serializer.serialize(firstName: firstName, lastName: lastName, email: email, phone: phone, streetAddress: street, city: city, state: state, zip: zip, referredBy: referredBy, projectNotes: projectNotes)
        return parameters
    }
}
