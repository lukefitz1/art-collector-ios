//
//  CollectionEditServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol CollectionEditServiceProtocol {
    func updateCollection(id: String,
                          name: String,
                          year: String,
                          identifier: String,
                          customerId: String,
                          updatedAt: String,
                          completionHandler: ((Collection?, Error?) -> Void)?)
}

extension CollectionEditService: CollectionEditServiceProtocol {}
