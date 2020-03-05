//
//  CollectionCreateServiceDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/9/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct CollectionCreateServiceDeserializer {
    func deserialize(response: Any) -> Collection? {
        do {
            let data = try JSONSerialization.data(withJSONObject: response)
            let deserializedCollection = try JSONDecoder().decode(Collection.self, from: data)
            return deserializedCollection
        } catch {
            print("Error deserializing collection: \(error)")
        }
        
        return nil
    }
}
