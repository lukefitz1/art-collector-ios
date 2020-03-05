//
//  CollectionCreateServiceDeserializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/9/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol CollectionCreateServiceDeserializerProtocol {
    func deserialize(response: Any) -> Collection?
}

extension CollectionCreateServiceDeserializer: CollectionCreateServiceDeserializerProtocol {}
