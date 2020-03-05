//
//  CustomersServiceDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/30/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct CustomersServiceDeserializer {
    func deserialize(response: Any) -> [Customer] {
        do {
            guard let responseArray = response as? [Any] else {
                return []
            }
            let data = try JSONSerialization.data(withJSONObject: responseArray)
            let deserializedCustomers = try JSONDecoder().decode([Customer].self, from: data)
            return deserializedCustomers
        } catch {
            print("Error deserializing customers: \(error)")
        }

        return []
    }
}
