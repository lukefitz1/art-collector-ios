//
//  CollectionCreateServiceSerializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/9/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

protocol CollectionCreateServiceSerializerProtocol {
    func serialize(name: String,
                   year: String,
                   identifier: String,
                   customerId: String) -> Parameters
}

extension CollectionCreateServiceSerializer: CollectionCreateServiceSerializerProtocol {}
