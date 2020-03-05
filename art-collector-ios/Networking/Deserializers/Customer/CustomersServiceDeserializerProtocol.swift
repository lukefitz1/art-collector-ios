//
//  CustomersServiceDeserializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/30/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol CustomersServiceDeserializerProtocol {
    func deserialize(response: Any) -> [Customer]
}

extension CustomersServiceDeserializer: CustomersServiceDeserializerProtocol {}
