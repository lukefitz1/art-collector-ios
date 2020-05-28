//
//  Customer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/28/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct Customer: Decodable, Equatable {
    static func == (lhs: Customer, rhs: Customer) -> Bool {
        return lhs.id == rhs.id &&
        lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.city == rhs.city &&
        lhs.state == rhs.state &&
        lhs.zip == rhs.zip &&
        lhs.address == rhs.address &&
        lhs.phone == rhs.phone &&
        lhs.email == rhs.email &&
        lhs.collections == rhs.collections &&
        lhs.createdAt == rhs.createdAt &&
        lhs.updatedAt == rhs.updatedAt
    }
    
    let id: String
    let firstName: String
    let lastName: String
    let city: String?
    let state: String?
    let zip: String?
    let address: String?
    let phone: String?
    let email: String?
    let collections: [Collection]?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case city
        case state
        case zip
        case address = "street_address"
        case phone = "phone_number"
        case email = "email_address"
        case collections
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
