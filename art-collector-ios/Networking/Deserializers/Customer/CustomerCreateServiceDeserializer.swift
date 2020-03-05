//
//  CustomerCreateServiceDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct CustomerCreateServiceDeserializer {
    func deserialize(response: Any) -> Customer? {
        do {
            let data = try JSONSerialization.data(withJSONObject: response)
            let deserializedCustomer = try JSONDecoder().decode(Customer.self, from: data)
            return deserializedCustomer
        } catch {
            print("Error deserializing customer: \(error)")
        }
        
        return nil
    }
}
