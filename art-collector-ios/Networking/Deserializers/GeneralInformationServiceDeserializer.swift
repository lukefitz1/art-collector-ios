//
//  GeneralInformationDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct GeneralInformationServiceDeserializer {
    func deserialize(response: Any) -> [GeneralInformation] {
        do {
            guard let responseArray = response as? [Any] else {
                return []
            }
            let data = try JSONSerialization.data(withJSONObject: responseArray)
            let deserializedGeneralInformation = try JSONDecoder().decode([GeneralInformation].self, from: data)
            return deserializedGeneralInformation
        } catch {
            print("Error deserializing general information: \(error)")
        }

        return []
    }
}
