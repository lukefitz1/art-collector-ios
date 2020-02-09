//
//  CollectionService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/30/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct CollectionService {
    var deserializer: CollectionServiceDeserializerProtocol
    
    init(deserializer: CollectionServiceDeserializerProtocol = CollectionServiceDeserializer()) {
        self.deserializer = deserializer
    }
    
    func getCollection(collectionId: String, completionHandler: ((Collection?, Error?) -> Void)?) {
        let endpoint = buildEndpoint(collectionId: collectionId)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiClient.authToken)"
        ]
        var data : Collection?
        
        AF.request(endpoint,
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
}
