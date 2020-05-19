//
//  ArtworkCore+CoreDataProperties.swift
//  
//
//  Created by Luke Fitzgerald on 5/16/20.
//
//

import Foundation
import CoreData


extension ArtworkCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtworkCore> {
        return NSFetchRequest<ArtworkCore>(entityName: "ArtworkCore")
    }

    @NSManaged public var additionalInfoImage: String?
    @NSManaged public var additionalInfoImageTwo: String?
    @NSManaged public var additionalInfoLabel: String?
    @NSManaged public var additionalInfoText: String?
    @NSManaged public var amountPaid: String?
    @NSManaged public var artDescription: String?
    @NSManaged public var artistId: UUID?
    @NSManaged public var artType: String?
    @NSManaged public var collectionId: UUID?
    @NSManaged public var condition: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var currentLocation: String?
    @NSManaged public var currentValue: String?
    @NSManaged public var customerId: UUID?
    @NSManaged public var customTitle: String?
    @NSManaged public var date: String?
    @NSManaged public var dateAcquired: String?
    @NSManaged public var dateAcquiredLabel: String?
    @NSManaged public var dimensions: String?
    @NSManaged public var frameDimensions: String?
    @NSManaged public var generalInformationId: UUID?
    @NSManaged public var id: UUID?
    @NSManaged public var image: String?
    @NSManaged public var medium: String?
    @NSManaged public var notes: String?
    @NSManaged public var notesImage: String?
    @NSManaged public var notesImageTwo: String?
    @NSManaged public var objectId: String?
    @NSManaged public var provenance: String?
    @NSManaged public var reviewedBy: String?
    @NSManaged public var reviewedDate: String?
    @NSManaged public var showGeneralInfo: Bool
    @NSManaged public var source: String?
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var artistIds: [String]?
    @NSManaged public var generalInfoIds: [String]?

}
