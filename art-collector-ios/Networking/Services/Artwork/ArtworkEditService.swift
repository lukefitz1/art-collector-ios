//
//  ArtworkEditService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct ArtworkEditService {
    
    let serializer: ArtworkEditServiceSerializerProtocol
    let deserializer: ArtworkCreateServiceDeserializerProtocol
    
    init(deserializer: ArtworkCreateServiceDeserializerProtocol = ArtworkCreateServiceDeserializer(),
         serializer: ArtworkEditServiceSerializerProtocol = ArtworkEditServiceSerializer()) {
        self.deserializer = deserializer
        self.serializer = serializer
    }
    
    func updateArtwork(id: String,
                       objectId: String,
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
                       customerId: String,
                       collectionId: String,
                       showGeneralInfo: Bool,
                       createdAt: String,
                       updatedAt: String,
                       artistIds: [String],
                       generalInfoIds: [String],
                       completionHandler: ((Artwork?, Error?) -> Void)?) {
        
        let fullEndpoint = buildEndpoint(artworkId: id)
        let headers: HTTPHeaders = [
            "access-token": ApiClient.accessToken,
            "client": ApiClient.client,
            "uid": ApiClient.uid,
            "expiry": ApiClient.expiry,
            "token-type": ApiClient.tokenType
        ]
        
        let parameters = buildParameters(objectId: objectId, artType: artType, title: title, date: date, medium: medium, description: description, mainImage: mainImage, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: customTitle, customerId: customerId, collectionId: collectionId, showGeneralInfo: showGeneralInfo, createdAt: createdAt, updatedAt: updatedAt, artistIds: artistIds, generalInfoIds: generalInfoIds)
        
        var data : Artwork?
        
        AF.request(fullEndpoint,
                   method: .put,
                   parameters: parameters,
                   encoding: JSONEncoding(),
                   headers: headers).responseJSON { responseJSON in
                    
                    switch responseJSON.result {
                    case .success:
                        if let safeData = responseJSON.data {
                            print("Successfully updated a piece of art via the API")
                            data = self.parseJSON(artworkData: safeData)
                        }
                        
                        completionHandler?(data, nil)
                    case let .failure(error):
                        print("Error updating a piece of art via the API")
                        print(error)
                        completionHandler?(nil, error)
                    }
        }
    }
    
    private func parseJSON(artworkData: Data) -> Artwork? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(Artwork.self, from: artworkData)
            return decodedData
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    private func buildEndpoint(artworkId: String) -> URL {
        return URL(string: "\(ApiClient.baseUrl)artwork/\(artworkId)")!
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
                                 customerId: String,
                                 collectionId: String,
                                 showGeneralInfo: Bool,
                                 createdAt: String,
                                 updatedAt: String,
                                 artistIds: [String],
                                 generalInfoIds: [String]) -> Parameters {
        
        let parameters = serializer.serialize(objectId: objectId, artType: artType, title: title, date: date, medium: medium, mainImage: mainImage, description: description, dimensions: dimensions, frameDimensions: frameDimensions, condition: condition, currentLocation: currentLocation, source: source, dateAcquiredLabel: dateAcquiredLabel, dateAcquired: dateAcquired, amountPaid: amountPaid, currentValue: currentValue, notes: notes, notesImage: notesImage, notesImageTwo: notesImageTwo, additionalInfoLabel: additionalInfoLabel, additionalInfoText: additionalInfoText, additionalInfoImage: additionalInfoImage, additionalInfoImageTwo: additionalInfoImageTwo, reviewedBy: reviewedBy, reviewedDate: reviewedDate, provenance: provenance, customTitle: customTitle, customerId: customerId, collectionId: collectionId, showGeneralInfo: showGeneralInfo, createdAt: createdAt, updatedAt: updatedAt, artistIds: artistIds, generalInfoIds: generalInfoIds)
        return parameters
    }
}

