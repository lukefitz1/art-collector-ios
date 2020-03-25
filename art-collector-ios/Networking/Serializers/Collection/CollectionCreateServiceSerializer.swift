//
//  CollectionCreateServiceSerializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/9/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct CollectionCreateServiceSerializer {
    func serialize(name: String,
                   year: String,
                   identifier: String,
                   customerId: String) -> Parameters {
        
        let parameters: Parameters = [ "collectionName": name,
                                       "year": year,
                                       "identifier": identifier,
                                       "customer_id": customerId]
        
        return parameters
    }
}


