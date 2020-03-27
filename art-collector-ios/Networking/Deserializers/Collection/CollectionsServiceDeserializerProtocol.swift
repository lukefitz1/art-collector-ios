//
//  CollectionsServiceDeserializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/26/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol CollectionsServiceDeserializerProtocol {
    func deserialize(response: Any) -> [Collection]
}

extension CollectionsServiceDeserializer: CollectionsServiceDeserializerProtocol {}
