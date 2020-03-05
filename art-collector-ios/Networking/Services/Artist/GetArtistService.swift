//
//  GetArtistService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct GetArtistService {
    var deserializer: GetArtistServiceDeserializerProtocol
    
    init(deserializer: GetArtistServiceDeserializerProtocol = GetArtistServiceDeserializer()) {
        self.deserializer = deserializer
    }
    
    func getArtistInfo(artistId: String, completionHandler: ((Artist?, Error?) -> Void)?) {
        let endpoint = buildEndpoint(id: artistId)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiClient.authToken)"
        ]
        
        var data : Artist?
        
        AF.request(endpoint,
                   headers: headers).responseJSON { responseJSON in
                    
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
    
    func parseJSON(artistData: Data) -> Artist? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(Artist.self, from: artistData)
            return decodedData
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    private func buildEndpoint(id: String) -> URL {
        return URL(string: "\(ApiClient.baseUrl)artist/\(id)")!
    }
}

