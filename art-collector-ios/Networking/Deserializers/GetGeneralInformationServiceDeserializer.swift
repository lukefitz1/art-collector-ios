//
//  GetGeneralInformationServiceDeserializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct GetGeneralInformationServiceDeserializer {
    func deserialize(response: Any) -> GeneralInformation? {
        do {
            let data = try JSONSerialization.data(withJSONObject: response)
            let deserializedGeneralInfo = try JSONDecoder().decode(GeneralInformation.self, from: data)
            return deserializedGeneralInfo
        } catch {
            print("Error deserializing general info: \(error)")
        }
        
        return nil
    }
}
