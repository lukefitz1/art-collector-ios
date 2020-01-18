//
//  GeneralInformation.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/3/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct GeneralInformation: Decodable {
    let id: String
    let infoLabel: String?
    let information: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case infoLabel = "information_label"
        case information
    }
}
