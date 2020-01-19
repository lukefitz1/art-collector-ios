//
//  ArtistCreateService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/18/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct ArtistCreateService {
    
    let serializer: ArtistCreateServiceSerializerProtocol
    let deserializer: ArtistCreateServiceDeserializerProtocol
    
    init(deserializer: ArtistCreateServiceDeserializerProtocol = ArtistCreateServiceDeserializer(),
         serializer: ArtistCreateServiceSerializerProtocol = ArtistCreateServiceSerializer()) {
        self.deserializer = deserializer
        self.serializer = serializer
    }
    
    func createArtist(fName: String,
                      lName: String,
                      bio: String,
                      additionalInfo: String,
                      image: String,
                      completionHandler: ((Artist?, Error?) -> Void)?) {
        let fullEndpoint = buildEndpoint()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiClient.authToken)"
        ]
        let parameters = buildParameters(firstName: fName, lastName: lName, biography: bio, additionalInfo: additionalInfo, artistImage: image)
        
        var data : Artist?
        
        AF.request(fullEndpoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding(),
                   headers: headers).responseJSON { responseJSON in
                     debugPrint(responseJSON)
                    
                    switch responseJSON.result {
                    case .success:
                        if let safeData = responseJSON.data {
                            data = self.parseJSON(artistData: safeData)
                        }
                        
                        completionHandler?(data, nil)
                        // let deserializedResponse = self.deserializer.deserialize(response: data)
                        // print(deserializedResponse)
                        // completionHandler?(deserializedResponse, nil)
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
    
    private func buildEndpoint() -> URL {
        return URL(string: "\(ApiClient.baseUrl)artist")!
    }
    
    private func buildParameters(firstName: String,
                                 lastName: String,
                                 biography: String,
                                 additionalInfo: String,
                                 artistImage: String) -> Parameters {
        
        let parameters = serializer.serialize(firstName: firstName, lastName: lastName, additionalInfo: additionalInfo, biography: biography, artistImage: artistImage)
        return parameters
    }
}
