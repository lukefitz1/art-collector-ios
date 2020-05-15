//
//  GetArtworkService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct GetArtworkService {
    var deserializer: GetArtworkServiceDeserializerProtocol
    
    init(deserializer: GetArtworkServiceDeserializerProtocol = GetArtworkServiceDeserializer()) {
        self.deserializer = deserializer
    }
    
    func getArtworkInfo(artworkId: String, completionHandler: ((Artwork?, Error?) -> Void)?) {
        let endpoint = buildEndpoint(id: artworkId)
        let headers: HTTPHeaders = [
            "access-token": ApiClient.accessToken,
            "client": ApiClient.client,
            "uid": ApiClient.uid,
            "expiry": ApiClient.expiry,
            "token-type": ApiClient.tokenType
        ]
        
        var data : Artwork?
        
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
    
    func parseJSON(artworkData: Data) -> Artwork? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(Artwork.self, from: artworkData)
            return decodedData
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    private func buildEndpoint(id: String) -> URL {
        return URL(string: "\(ApiClient.baseUrl)artwork/\(id)")!
    }
}
