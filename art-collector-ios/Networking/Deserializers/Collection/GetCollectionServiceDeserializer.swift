//
//  GetCollectionServiceDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct GetCollectionServiceDeserializer {
    func deserialize(response: Any) -> Collection? {
        do {
            let data = try JSONSerialization.data(withJSONObject: response)
            let deserializedCollection = try JSONDecoder().decode(Collection.self, from: data)
            return deserializedCollection
        } catch {
            print("Error deserializing collection info: \(error)")
        }
        
        return nil
    }
}
