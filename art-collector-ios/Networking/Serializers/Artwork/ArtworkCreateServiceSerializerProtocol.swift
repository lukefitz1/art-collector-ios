//
//  ArtworkCreateServiceSerializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/30/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

protocol ArtworkCreateServiceSerializerProtocol {
    func serialize(id: String,
                   objectId: String,
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
                   artistId: String,
                   generalInformationId: String,
                   showGeneralInfo: Bool,
                   createdAt: String,
                   updatedAt: String,
                   artistIds: [String],
                   generalInfoIds: [String]) -> Parameters
}

extension ArtworkCreateServiceSerializer: ArtworkCreateServiceSerializerProtocol {}
