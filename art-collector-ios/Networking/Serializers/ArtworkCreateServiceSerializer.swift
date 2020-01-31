//
//  ArtworkCreateServiceSerializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/30/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct ArtworkCreateServiceSerializer {
    func serialize(objectId: String,
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
                   collectionId: String) -> Parameters {
        
        let parameters: Parameters = [ "ojbId": objectId,
                                       "artType": artType,
                                       "title": title,
                                       "date": date,
                                       "medium": date,
                                       "image": mainImage,
                                       "description": description,
                                       "dimensions": dimensions,
                                       "frame_dimensions": frameDimensions,
                                       "condition": condition,
                                       "currentLocation": currentLocation,
                                       "source": source,
                                       "dateAcquired": dateAcquired,
                                       "amountPaid": amountPaid,
                                       "currentValue": currentValue,
                                       "notes": notes,
                                       "additionalInfoLabel": additionalInfoLabel,
                                       "additionalInfoText": additionalInfoText,
                                       "reviewedBy": reviewedBy,
                                       "reviewedDate": reviewedDate,
                                       "provenance": provenance,
                                       "dateAcquiredLabel": dateAcquiredLabel,
                                       "artist_id": "",
                                       "notesImage": notesImage,
                                       "additionalInfoImage": additionalInfoImage,
                                       "notesImageTwo": notesImageTwo,
                                       "additionalInfoImageTwo": additionalInfoImageTwo,
                                       "customer_id": customerId,
                                       "collection_id": collectionId]
        
        return parameters
    }
}
