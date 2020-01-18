//
//  Customer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/28/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct Customer: Decodable {
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
    }
}
