//
//  Artwork.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/3/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct Artwork: Decodable {
    let id: String
    let objectId: String?
    let artType: String?
    let title: String?
    let date: String?
    let medium: String?
    let image: Image?
    let description: String?
    let dimensions: String?
    let frameDimensions: String?
    let condition: String?
    let currentLocation: String?
    let source: String?
    let dateAcquired: String?
    let amountPaid: String?
    let currentValue: String?
    let notes: String?
    let notesImage: Image?
    let additionalInfoLabel: String?
    let additionalInfoText: String?
    let additionalInfoImage: Image?
    let additionalPdf: Pdf?
    let reviewedBy: String?
    let reviewedDate: String?
    let provenance: String?
    let dateAcquiredLabel: String?
    let artistId: String?
    let collectionId: String?
    let customerId: String?
    let notesImageTwo: Image?
    let additionalInfoImageTwo: Image?
    let generalInfoId: String?
    let showGeneralInfo: Bool?
    let customTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case objectId = "ojbId"
        case artType
        case title
        case date
        case medium
        case image
        case description
        case dimensions
        case frameDimensions = "frame_dimensions"
        case condition
        case currentLocation
        case source
        case dateAcquired
        case amountPaid
        case currentValue
        case notes
        case notesImage
        case additionalInfoLabel
        case additionalInfoText
        case additionalInfoImage
        case additionalPdf
        case reviewedBy
        case reviewedDate
        case provenance
        case dateAcquiredLabel
        case artistId = "artist_id"
        case collectionId = "collection_id"
        case customerId = "customer_id"
        case notesImageTwo
        case additionalInfoImageTwo
        case generalInfoId = "general_information_id"
        case showGeneralInfo = "show_general_info"
        case customTitle = "custom_title"
    }
}
