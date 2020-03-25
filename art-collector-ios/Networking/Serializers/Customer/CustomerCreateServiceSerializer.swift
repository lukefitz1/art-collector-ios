//
//  CustomerCreateServiceSerializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct CustomerCreateServiceSerializer {
    func serialize(firstName: String,
                   lastName: String,
                   email: String,
                   phone: String,
                   streetAddress: String,
                   city: String,
                   state: String,
                   zip: String,
                   referredBy: String,
                   projectNotes: String) -> Parameters {
        
        let parameters: Parameters = [ "firstName": firstName,
                                       "lastName": lastName,
                                       "email_address": email,
                                       "phone_number": phone,
                                       "street_address": streetAddress,
                                       "city": city,
                                       "state": state,
                                       "zip": zip,
                                       "referred_by": referredBy,
                                       "project_notes": projectNotes]
        
        return parameters
    }
}
