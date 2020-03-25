//
//  CollectionEditServiceSerializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/25/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct CollectionEditServiceSerializer {
    func serialize(collectionName: String,
                   identifier: String,
                   year: String,
//                   artworks: [Artwork] // TODO
                   customerId: String,
                   createdAt: String,
                   updatedAt: String) -> Parameters {
        
        let parameters: Parameters = [ "collectionName": collectionName,
                                       "identifier": identifier,
                                       "year": year,
                                       "customer_id": customerId,
                                       "created_at": createdAt,
                                       "updated_at": updatedAt]
        
        return parameters
    }
}
