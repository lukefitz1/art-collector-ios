//
//  GetArtistServiceDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct GetArtistServiceDeserializer {
    func deserialize(response: Any) -> Artist? {
        do {
            let data = try JSONSerialization.data(withJSONObject: response)
            let deserializedArtist = try JSONDecoder().decode(Artist.self, from: data)
            return deserializedArtist
        } catch {
            print("Error deserializing artist info: \(error)")
        }
        
        return nil
    }
}
