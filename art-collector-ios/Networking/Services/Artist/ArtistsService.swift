//
//  ArtistsService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct ArtistsService {
    var deserializer: ArtistsServiceDeserializerProtocol
        
        init(deserializer: ArtistsServiceDeserializerProtocol = ArtistsServiceDeserializer()) {
            self.deserializer = deserializer
        }
        
        func getArtists(completionHandler: (([Artist]?, Error?) -> Void)?) {
            let endpoint = buildEndpoint()
            let headers: HTTPHeaders = [
                "access-token": ApiClient.accessToken,
                "client": ApiClient.client,
                "uid": ApiClient.uid,
                "expiry": ApiClient.expiry,
                "token-type": ApiClient.tokenType
            ]
            var data : [Artist] = []
            
            AF.request(endpoint,
                       headers: headers).responseJSON { responseJSON in
//                 debugPrint(responseJSON)
                        
                        switch responseJSON.result {
                            case .success:
                                if let safeData = responseJSON.data {
                                    data = self.parseJSON(artistData: safeData)
                                }
                                
                                completionHandler?(data, nil)
                            case let .failure(error):
                                print(error)
                                completionHandler?(nil, error)
                        }
            }
        }
        
    func parseJSON(artistData: Data) -> [Artist] {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([Artist].self, from: artistData)
            return decodedData
        } catch  {
            print(error)
        }
        
        return []
    }
        
    private func buildEndpoint() -> URL {
        return URL(string: "\(ApiClient.baseUrl)artist")!
    }
}
