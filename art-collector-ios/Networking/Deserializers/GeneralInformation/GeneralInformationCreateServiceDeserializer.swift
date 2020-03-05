//
//  GeneralInformationCreateServiceDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/20/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct GeneralInformationCreateServiceDeserializer {
    func deserialize(response: Any) -> GeneralInformation? {
        do {
            let data = try JSONSerialization.data(withJSONObject: response)
            let deserializedGeneralInformation = try JSONDecoder().decode(GeneralInformation.self, from: data)
            return deserializedGeneralInformation
        } catch {
            print("Error deserializing general information: \(error)")
        }
        
        return nil
    }
}
