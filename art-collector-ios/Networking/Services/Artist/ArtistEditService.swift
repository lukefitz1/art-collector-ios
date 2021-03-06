//
//  ArtistEditService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct ArtistEditService {
    
    let serializer: ArtistEditServiceSerializerProtocol
    let deserializer: ArtistCreateServiceDeserializerProtocol
    
    init(deserializer: ArtistCreateServiceDeserializerProtocol = ArtistCreateServiceDeserializer(),
         serializer: ArtistEditServiceSerializerProtocol = ArtistEditServiceSerializer()) {
        self.deserializer = deserializer
        self.serializer = serializer
    }
    
    func updateArtist(id: String,
                      fName: String,
                      lName: String,
                      bio: String,
                      additionalInfo: String,
                      image: String,
                      createdAt: String,
                      updatedAt: String,
                      completionHandler: ((Artist?, Error?) -> Void)?) {
        
        let fullEndpoint = buildEndpoint(artistId: id)
        let headers: HTTPHeaders = [
            "access-token": ApiClient.accessToken,
            "client": ApiClient.client,
            "uid": ApiClient.uid,
            "expiry": ApiClient.expiry,
            "token-type": ApiClient.tokenType
        ]
        let parameters = buildParameters(firstName: fName, lastName: lName, biography: bio, additionalInfo: additionalInfo, artistImage: image, createdAt: createdAt, updatedAt: updatedAt)
        
        var data : Artist?
        
        AF.request(fullEndpoint,
                   method: .put,
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
                    case let .failure(error):
                        print(error)
                        completionHandler?(nil, error)
                    }
        }
    }
    
    private func parseJSON(artistData: Data) -> Artist? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(Artist.self, from: artistData)
            return decodedData
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    private func buildEndpoint(artistId: String) -> URL {
        return URL(string: "\(ApiClient.baseUrl)artist/\(artistId)")!
    }
    
    private func buildParameters(firstName: String,
                                 lastName: String,
                                 biography: String,
                                 additionalInfo: String,
                                 artistImage: String,
                                 createdAt: String,
                                 updatedAt: String) -> Parameters {
        
        let parameters = serializer.serialize(firstName: firstName, lastName: lastName, additionalInfo: additionalInfo, biography: biography, artistImage: artistImage, createdAt: createdAt, updatedAt: updatedAt)
        return parameters
    }
}
