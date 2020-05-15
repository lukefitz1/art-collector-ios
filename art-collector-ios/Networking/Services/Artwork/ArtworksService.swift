//
//  ArtworksService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/26/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct ArtworksService {
    var deserializer: ArtworksServiceDeserializerProtocol
    
    init(deserializer: ArtworksServiceDeserializerProtocol = ArtworksServiceDeserializer()) {
        self.deserializer = deserializer
    }
    
    func getArtworks(completionHandler: (([Artwork]?, Error?) -> Void)?) {
        let endpoint = buildEndpoint()
        let headers: HTTPHeaders = [
            "access-token": ApiClient.accessToken,
            "client": ApiClient.client,
            "uid": ApiClient.uid,
            "expiry": ApiClient.expiry,
            "token-type": ApiClient.tokenType
        ]
        var data : [Artwork] = []
        
        AF.request(endpoint,
                   headers: headers).responseJSON { responseJSON in
                    switch responseJSON.result {
                        case .success:
                            if let safeData = responseJSON.data {
                                data = self.parseJSON(artworkData: safeData)
                            }
                            
                            completionHandler?(data, nil)
                        case let .failure(error):
                            print(error)
                            completionHandler?(nil, error)
                    }
        }
    }
    
    func parseJSON(artworkData: Data) -> [Artwork] {
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode([Artwork].self, from: artworkData)
                return decodedData
            } catch  {
                print(error)
            }
        
            return []
        }
    
    private func buildEndpoint() -> URL {
        return URL(string: "\(ApiClient.baseUrl)artwork")!
    }
}
