//
//  CustomerEditServiceSerializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/25/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

protocol CustomerEditServiceSerializerProtocol {
    func serialize(firstName: String,
                   lastName: String,
                   emailAddress: String,
                   phoneNumber: String,
                   streetAddress: String,
                   city: String,
                   state: String,
                   zipCode: String,
                   referredBy: String,
                   projectNotes: String,
                   createdAt: String,
                   updatedAt: String) -> Parameters
}

extension CustomerEditServiceSerializer: CustomerEditServiceSerializerProtocol {}
