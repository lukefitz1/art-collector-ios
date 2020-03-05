//
//  CustomerCreateServiceDeserializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol CustomerCreateServiceDeserializerProtocol {
    func deserialize(response: Any) -> Customer?
}

extension CustomerCreateServiceDeserializer: CustomerCreateServiceDeserializerProtocol {}
