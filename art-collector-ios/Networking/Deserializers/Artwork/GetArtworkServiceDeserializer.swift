//
//  GetArtworkServiceDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct GetArtworkServiceDeserializer {
    func deserialize(response: Any) -> Artwork? {
        do {
            let data = try JSONSerialization.data(withJSONObject: response)
            let deserializedArtwork = try JSONDecoder().decode(Artwork.self, from: data)
            return deserializedArtwork
        } catch {
            print("Error deserializing artwork info: \(error)")
        }
        
        return nil
    }
}
