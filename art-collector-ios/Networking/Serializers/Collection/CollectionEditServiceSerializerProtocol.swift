//
//  CollectionEditServiceSerializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/25/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

protocol CollectionEditServiceSerializerProtocol {
    func serialize(collectionName: String,
                   identifier: String,
                   year: String,
                   customerId: String,
                   updatedAt: String) -> Parameters
}

extension CollectionEditServiceSerializer: CollectionEditServiceSerializerProtocol {}
