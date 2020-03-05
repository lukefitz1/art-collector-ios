//
//  GetCustomerServiceDeserializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/9/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol GetCustomerServiceDeserializerProtocol {
    func deserialize(response: Any) -> Customer?
}

extension GetCustomerServiceDeserializer: GetCustomerServiceDeserializerProtocol {}
