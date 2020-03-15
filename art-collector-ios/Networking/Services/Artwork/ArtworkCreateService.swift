//
//  ArtworkCreateService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/30/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct ArtworkCreateService {
    
    let serializer: ArtworkCreateServiceSerializerProtocol
    let deserializer: ArtworkCreateServiceDeserializerProtocol
    
    init(deserializer: ArtworkCreateServiceDeserializerProtocol = ArtworkCreateServiceDeserializer(),
         serializer: ArtworkCreateServiceSerializerProtocol = ArtworkCreateServiceSerializer()) {
        self.deserializer = deserializer
        self.serializer = serializer
    }
    
    func createArtwork(objectId: String,
                       artType: String,
                       title: String,
                       date: String,
                       medium: String,
                       description: String,
                       mainImage: String,
                       dimensions: String,
                       frameDimensions: String,
                       condition: String,
                       currentLocation: String,
                       source: String,
                       dateAcquiredLabel: String,
                       dateAcquired: String,
                       amountPaid: String,
                       currentValue: String,
                       notes: String,
                       notesImage: String,
                       notesImageTwo: String,
                       additionalInfoLabel: String,
                       additionalInfoText: String,
                       additionalInfoImage: String,
                       additionalInfoImageTwo: String,
                       reviewedBy: String,
                       reviewedDate: String,
                       provenance: String,
                       customTitle: String,
                       additionalInfo: String,
                       customerId: String,
                       collectionId: String,
                       artistId: String,
                       completionHandler: ((Artwork?, Error?) -> Void)?) {
        
        let fullEndpoint = buildEndpoint()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiClient.authToken)"
        ]
        
        let parameters = buildParameters(objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: customTitle, additionalInfo: additionalInfo, customerId: customerId, collectionId: collectionId, artistId: artistId)
        
        var data : Artwork?
        
        AF.request(fullEndpoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding(),
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
    
    private func buildEndpoint() -> URL {
        return URL(string: "\(ApiClient.baseUrl)artwork")!
    }
    
    private func buildParameters(objectId: String,
                                 artType: String,
                                 title: String,
                                 date: String,
                                 medium: String,
                                 description: String,
                                 mainImage: String,
                                 dimensions: String,
                                 frameDimensions:  String,
                                 condition: String,
                                 currentLocation: String,
                                 source: String,
                                 dateAcquiredLabel: String,
                                 dateAcquired: String,
                                 amountPaid: String,
                                 currentValue: String,
                                 notes: String,
                                 notesImage: String,
                                 notesImageTwo: String,
                                 additionalInfoLabel: String,
                                 additionalInfoText: String,
                                 additionalInfoImage: String,
                                 additionalInfoImageTwo: String,
                                 reviewedBy: String,
                                 reviewedDate: String,
                                 provenance: String,
                                 customTitle: String,
                                 additionalInfo: String,
                                 customerId: String,
                                 collectionId: String,
                                 artistId: String) -> Parameters {
        
        let parameters = serializer.serialize(objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: customTitle, additionalInfo: additionalInfo, customerId: customerId, collectionId: collectionId, artistId: artistId)
        return parameters
    }
}
