//
//  CustomerEditServiceSerializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/25/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct CustomerEditServiceSerializer {
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
                   updatedAt: String) -> Parameters {
        
        let parameters: Parameters = [ "firstName": firstName,
                                       "lastName": lastName,
                                       "email_address": emailAddress,
                                       "phone_number": phoneNumber,
                                       "street_address": streetAddress,
                                       "city": city,
                                       "state": state,
                                       "zip": zipCode,
                                       "referred_by": referredBy,
                                       "project_notes": projectNotes,
                                       "created_at": createdAt,
                                       "updated_at": updatedAt]
        
        return parameters
    }
}
