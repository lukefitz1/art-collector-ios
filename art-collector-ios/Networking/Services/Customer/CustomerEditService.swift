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
    
    let serializer: CustomerEditServiceSerializerProtocol
    let deserializer: CustomerCreateServiceDeserializerProtocol
    
    init(deserializer: CustomerCreateServiceDeserializerProtocol = CustomerCreateServiceDeserializer(),
         serializer: CustomerEditServiceSerializerProtocol = CustomerEditServiceSerializer()) {
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
                        createdAt: String,
                        updatedAt: String,
                        completionHandler: ((Customer?, Error?) -> Void)?) {
        
        let fullEndpoint = buildEndpoint(customerId: id)
        let headers: HTTPHeaders = [
            "access-token": ApiClient.accessToken,
            "client": ApiClient.client,
            "uid": ApiClient.uid,
            "expiry": ApiClient.expiry,
            "token-type": ApiClient.tokenType
        ]
        
        let parameters = buildParameters(firstName: fName, lastName: lName, email: email, phone: phone, street: address, city: city, state: state, zip: zip, referredBy: referredBy, projectNotes: projectNotes, createdAt: createdAt, updatedAt: updatedAt)
        
        var data : Customer?
        
        AF.request(fullEndpoint,
                   method: .put,
                   parameters: parameters,
                   encoding: JSONEncoding(),
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
    
    private func buildParameters(firstName: String,
                                 lastName: String,
                                 email: String,
                                 phone: String,
                                 street: String,
                                 city: String,
                                 state: String,
                                 zip: String,
                                 referredBy: String,
                                 projectNotes: String,
                                 createdAt: String,
                                 updatedAt: String) -> Parameters {
        
        let parameters = serializer.serialize(firstName: firstName, lastName: lastName, emailAddress: email, phoneNumber: phone, streetAddress: street, city: city, state: state, zipCode: zip, referredBy: referredBy, projectNotes: projectNotes, createdAt: createdAt, updatedAt: updatedAt)
        return parameters
    }
}
