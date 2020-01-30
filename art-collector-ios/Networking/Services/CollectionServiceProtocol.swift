//
//  CollectionServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/30/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol CollectionServiceProtocol {
    func getCollection(completionHandler: ((Collection?, Error?) -> Void)?)
}

extension CollectionService: CollectionServiceProtocol {}
