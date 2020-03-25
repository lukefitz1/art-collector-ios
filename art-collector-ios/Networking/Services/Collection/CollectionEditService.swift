//
//  CollectionEditService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct CollectionEditService {
    
    let serializer: CollectionEditServiceSerializerProtocol
    let deserializer: CollectionCreateServiceDeserializerProtocol
    
    init(deserializer: CollectionCreateServiceDeserializerProtocol = CollectionCreateServiceDeserializer(),
         serializer: CollectionEditServiceSerializerProtocol = CollectionEditServiceSerializer()) {
        self.deserializer = deserializer
        self.serializer = serializer
    }
    
    func updateCollection(id: String,
                          name: String,
                          year: String,
                          identifier: String,
                          customerId: String,
                          createdAt: String,
                          updatedAt: String,
                          completionHandler: ((Collection?, Error?) -> Void)?) {
        
        let fullEndpoint = buildEndpoint(collectionId: id)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiClient.authToken)"
        ]
        let parameters = buildParameters(name: name, year: year, identifier: identifier, customerId: customerId, createdAt: createdAt, updatedAt: updatedAt)
        
        var data : Collection?
        
        AF.request(fullEndpoint,
                   method: .put,
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
    
    private func buildEndpoint(collectionId: String) -> URL {
        return URL(string: "\(ApiClient.baseUrl)collections/\(collectionId)")!
    }
    
    private func buildParameters(name: String,
                                 year: String,
                                 identifier: String,
                                 customerId: String,
                                 createdAt: String,
                                 updatedAt: String) -> Parameters {
        
        let parameters = serializer.serialize(collectionName: name, identifier: identifier, year: year, customerId: customerId, createdAt: createdAt, updatedAt: updatedAt)
        return parameters
    }
}
