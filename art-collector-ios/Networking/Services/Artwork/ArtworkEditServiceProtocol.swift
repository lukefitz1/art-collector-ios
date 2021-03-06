//
//  ArtworkEditServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol ArtworkEditServiceProtocol {
    func updateArtwork(id: String,
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
                       showGeneralInfo: Bool,
                       createdAt: String,
                       updatedAt: String,
                       artistIds: [String],
                       generalInfoIds: [String],
                       completionHandler: ((Artwork?, Error?) -> Void)?)
}

extension ArtworkEditService: ArtworkEditServiceProtocol {}
