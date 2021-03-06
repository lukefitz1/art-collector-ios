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
    func serialize(id: String,
                   name: String,
                   year: String,
                   identifier: String,
                   customerId: String,
                   createdAt: String,
                   updatedAt: String) -> Parameters {
        
        let parameters: Parameters = [ "id": id,
                                       "collectionName": name,
                                       "year": year,
                                       "identifier": identifier,
                                       "customer_id": customerId,
                                       "created_at": createdAt,
                                       "updated_at": updatedAt]
        
        return parameters
    }
}


