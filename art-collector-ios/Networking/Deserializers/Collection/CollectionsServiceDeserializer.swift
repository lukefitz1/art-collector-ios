
//
//  CollectionsServiceDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/26/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct CollectionsServiceDeserializer {
    func deserialize(response: Any) -> [Collection] {
        do {
            guard let responseArray = response as? [Any] else {
                return []
            }
            let data = try JSONSerialization.data(withJSONObject: responseArray)
            let deserializedCollections = try JSONDecoder().decode([Collection].self, from: data)
            return deserializedCollections
        } catch {
            print("Error deserializing collections: \(error)")
        }

        return []
    }
}
