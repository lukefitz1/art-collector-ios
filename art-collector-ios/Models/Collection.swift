//
//  Collection.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/3/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct Collection: Decodable, Equatable {
    static func == (lhs: Collection, rhs: Collection) -> Bool {
        return lhs.id == rhs.id &&
            lhs.collectionName == rhs.collectionName &&
            lhs.identifier == rhs.identifier &&
            lhs.year == rhs.year &&
            lhs.artworks == rhs.artworks &&
            lhs.customerId == rhs.customerId &&
            lhs.createdAt == rhs.createdAt &&
            lhs.updatedAt == rhs.updatedAt
    }
    
    let id: String
    let collectionName: String?
    let identifier: String?
    let year: String?
    let artworks: [Artwork]?
    let customerId: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case collectionName
        case identifier
        case year
        case artworks
        case customerId = "customer_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
