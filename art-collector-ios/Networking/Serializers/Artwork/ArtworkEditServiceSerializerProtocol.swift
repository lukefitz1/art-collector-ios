//
//  ArtworkEditServiceSerializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/25/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

protocol ArtworkEditServiceSerializerProtocol {
    func serialize(objectId: String,
                   artType: String,
                   title: String,
                   medium: String,
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
                   additionalInfoLabel: String,
                   additionalInfoText: String,
                   reviewedBy: String,
                   reviewedDate: String,
                   provenance: String,
                   dateAcquiredLabel: String,
                   artistId: String,
                   customerId: String,
                   collectionId: String,
                   createdAt: String,
                   updatedAt: String) -> Parameters
}

extension ArtworkEditServiceSerializer: ArtworkEditServiceSerializerProtocol {}
