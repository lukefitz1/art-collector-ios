//
//  CollectionCreateService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/9/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct CollectionCreateService {
    
    let serializer: CollectionCreateServiceSerializerProtocol
    let deserializer: CollectionCreateServiceDeserializerProtocol
    
    init(deserializer: CollectionCreateServiceDeserializerProtocol = CollectionCreateServiceDeserializer(),
         serializer: CollectionCreateServiceSerializerProtocol = CollectionCreateServiceSerializer()) {
        self.deserializer = deserializer
        self.serializer = serializer
    }
    
    func createCollection(id: String,
                          name: String,
                          year: String,
                          identifier: String,
                          customerId: String,
                          createdAt: String,
                          updatedAt: String,
                          completionHandler: ((Collection?, Error?) -> Void)?) {
        
        let fullEndpoint = buildEndpoint()
        let headers: HTTPHeaders = [
            "access-token": ApiClient.accessToken,
            "client": ApiClient.client,
            "uid": ApiClient.uid,
            "expiry": ApiClient.expiry,
            "token-type": ApiClient.tokenType
        ]
        let parameters = buildParameters(id: id, name: name, year: year, identifier: identifier, customerId: customerId, createdAt: createdAt, updatedAt: updatedAt)
        
        var data : Collection?
        
        AF.request(fullEndpoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding(),
                   headers: headers).responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success:
                        if let safeData = responseJSON.data {
                            data = self.parseJSON(collectionData: safeData)
                        }
                        
                        completionHandler?(data, nil)
                    case let .failure(error):
                        print(error)
                        completionHandler?(nil, error)
                    }
        }
    }
    
    func parseJSON(collectionData: Data) -> Collection? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(Collection.self, from: collectionData)
            return decodedData
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    private func buildEndpoint() -> URL {
        return URL(string: "\(ApiClient.baseUrl)collections")!
    }
    
    private func buildParameters(id: String,
                                 name: String,
                                 year: String,
                                 identifier: String,
                                 customerId: String,
                                 createdAt: String,
                                 updatedAt: String) -> Parameters {
        
        let parameters = serializer.serialize(id: id, name: name, year: year, identifier: identifier, customerId: customerId, createdAt: createdAt, updatedAt: updatedAt)
        return parameters
    }
    
}
