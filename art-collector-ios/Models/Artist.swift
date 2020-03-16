//
//  Artist.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/3/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct Artist: Decodable {
    let id: String
    let firstName: String?
    let lastName: String?
    let biography: String?
    let additionalInfo: String?
    let artistImage: Image?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case biography
        case additionalInfo
        case artistImage = "artist_image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
