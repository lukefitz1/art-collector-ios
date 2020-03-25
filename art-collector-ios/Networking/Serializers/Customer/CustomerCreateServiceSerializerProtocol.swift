//
//  CustomerCreateServiceSerializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

protocol CustomerCreateServiceSerializerProtocol {
    func serialize(id: String,
                   firstName: String,
                   lastName: String,
                   email: String,
                   phone: String,
                   streetAddress: String,
                   city: String,
                   state: String,
                   zip: String,
                   referredBy: String,
                   projectNotes: String,
                   createdAt: String,
                   updatedAt: String) -> Parameters
}

extension CustomerCreateServiceSerializer: CustomerCreateServiceSerializerProtocol {}
