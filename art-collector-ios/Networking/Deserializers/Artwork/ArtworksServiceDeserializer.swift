//
//  ArtworksServiceDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/26/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct ArtworksServiceDeserializer {
    func deserialize(response: Any) -> [Artwork] {
        do {
            guard let responseArray = response as? [Any] else {
                return []
            }
            let data = try JSONSerialization.data(withJSONObject: responseArray)
            let deserializedArtwork = try JSONDecoder().decode([Artwork].self, from: data)
            return deserializedArtwork
        } catch {
            print("Error deserializing artwork: \(error)")
        }

        return []
    }
}
