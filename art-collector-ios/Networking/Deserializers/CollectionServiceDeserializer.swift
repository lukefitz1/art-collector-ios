//
//  CollectionServiceDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/30/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct CollectionServiceDeserializer {
    func deserialize(response: Any) -> Collection? {
        do {
            guard let responseArray = response as? [Any] else {
                return nil
            }
            let data = try JSONSerialization.data(withJSONObject: responseArray)
            let deserializedCollection = try JSONDecoder().decode(Collection?.self, from: data)
            return deserializedCollection
        } catch {
            print("Error deserializing collection: \(error)")
        }

        return nil
    }
}
