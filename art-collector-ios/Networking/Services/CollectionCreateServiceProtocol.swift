//
//  CollectionCreateServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/9/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol CollectionCreateServiceProtocol {
    func createCollection(name: String,
                          year: String,
                          identifier: String,
                          customerId: String,
                          completionHandler: ((Collection?, Error?) -> Void)?)
}

extension CollectionCreateService: CollectionCreateServiceProtocol {}
