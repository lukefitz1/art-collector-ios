//
//  ArtistsServiceDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct ArtistsServiceDeserializer {
    func deserialize(response: Any) -> [Artist] {
        do {
            guard let responseArray = response as? [Any] else {
                return []
            }
            let data = try JSONSerialization.data(withJSONObject: responseArray)
            let deserializedArtists = try JSONDecoder().decode([Artist].self, from: data)
            return deserializedArtists
        } catch {
            print("Error deserializing artists: \(error)")
        }

        return []
    }
}
