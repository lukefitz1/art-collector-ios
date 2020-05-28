//
//  Artwork.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/3/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct Artwork: Decodable, Equatable {
    static func == (lhs: Artwork, rhs: Artwork) -> Bool {
        return lhs.id == rhs.id &&
            lhs.objectId == rhs.objectId &&
            lhs.artType == rhs.artType &&
            lhs.title == rhs.title &&
            lhs.date == rhs.date &&
            lhs.medium == rhs.medium &&
            lhs.image == rhs.image &&
            lhs.description == rhs.description &&
            lhs.dimensions == rhs.dimensions &&
            lhs.frameDimensions == rhs.frameDimensions &&
            lhs.condition == rhs.condition &&
            lhs.currentLocation == rhs.currentLocation &&
            lhs.source == rhs.source &&
            lhs.dateAcquired == rhs.dateAcquired &&
            lhs.amountPaid == rhs.amountPaid &&
            lhs.currentValue == rhs.currentValue &&
            lhs.notes == rhs.notes &&
            lhs.notesImage == rhs.notesImage &&
            lhs.additionalInfoLabel == rhs.additionalInfoLabel &&
            lhs.additionalInfoText == rhs.additionalInfoText &&
            lhs.additionalInfoImage == rhs.additionalInfoImage &&
            lhs.additionalPdf == rhs.additionalPdf &&
            lhs.reviewedBy == rhs.reviewedBy &&
            lhs.reviewedDate == rhs.reviewedDate &&
            lhs.provenance == rhs.provenance &&
            lhs.dateAcquiredLabel == rhs.dateAcquiredLabel &&
            lhs.collectionId == rhs.collectionId &&
            lhs.customerId == rhs.customerId &&
            lhs.notesImageTwo == rhs.notesImageTwo &&
            lhs.additionalInfoImageTwo == rhs.additionalInfoImageTwo &&
            lhs.showGeneralInfo == rhs.showGeneralInfo &&
            lhs.customTitle == rhs.customTitle &&
            lhs.artistIds == rhs.artistIds &&
            lhs.generalInfoIds == rhs.generalInfoIds &&
            lhs.createdAt == rhs.createdAt &&
            lhs.updatedAt == rhs.updatedAt
    }
    
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
    let collectionId: String?
    let customerId: String?
    let notesImageTwo: Image?
    let additionalInfoImageTwo: Image?
    let showGeneralInfo: Bool?
    let customTitle: String?
    let createdAt: String
    let updatedAt: String
    
    let artistId: String?
    let generalInfoId: String?
    
    let artistIds: [String]?
    let generalInfoIds: [String]?
    
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
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case artistIds = "artist_ids"
        case generalInfoIds = "general_information_ids"
    }
}
