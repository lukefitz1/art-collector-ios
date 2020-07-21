//
//  CollectionsService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/26/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct CollectionsService {
    var deserializer: CollectionsServiceDeserializerProtocol
    
    init(deserializer: CollectionsServiceDeserializerProtocol = CollectionsServiceDeserializer()) {
        self.deserializer = deserializer
    }
    
    func getCollections(completionHandler: (([Collection]?, Error?) -> Void)?) {
        let endpoint = buildEndpoint()
        let headers: HTTPHeaders = [
            "access-token": ApiClient.accessToken,
            "client": ApiClient.client,
            "uid": ApiClient.uid,
            "expiry": ApiClient.expiry,
            "token-type": ApiClient.tokenType
        ]
        var data : [Collection] = []
        
        print("Network Request: \(endpoint)")
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
    
    func parseJSON(collectionData: Data) -> [Collection] {
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode([Collection].self, from: collectionData)
                return decodedData
            } catch  {
                print(error)
            }
        
            return []
        }
    
    private func buildEndpoint() -> URL {
        return URL(string: "\(ApiClient.baseUrl)collection")!
    }
}
