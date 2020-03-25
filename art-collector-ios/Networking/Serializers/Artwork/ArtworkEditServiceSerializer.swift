//
//  ArtworkEditServiceSerializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/25/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct ArtworkEditServiceSerializer {
    func serialize(objectId: String,
                   artType: String,
                   title: String,
                   date: String,
                   medium: String,
                   mainImage: String,
                   description: String,
                   dimensions: String,
                   frameDimensions: String,
                   condition: String,
                   currentLocation: String,
                   source: String,
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
                   dateAcquiredLabel: String,
                   customTitle: String,
                   artistId: String,
                   customerId: String,
                   collectionId: String,
                   generalInformationId: String,
                   showGeneralInfo: Bool,
                   createdAt: String,
                   updatedAt: String) -> Parameters {
        
        let parameters: Parameters = [ "ojbId": objectId,
                                       "artType": artType,
                                       "title": title,
                                       "date": date,
                                       "medium": medium,
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
                                       "custom_title": customTitle,
                                       "artist_id": artistId,
                                       "customer_id": customerId,
                                       "collection_id": collectionId,
                                       "general_information_id": generalInformationId,
                                       "show_general_info": showGeneralInfo,
                                       "created_at": createdAt,
                                       "updated_at": updatedAt]
        
        return parameters
    }
}
