//
//  GeneralInformationCreateServiceDeserializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/20/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol GeneralInformationCreateServiceDeserializerProtocol {
    func deserialize(response: Any) -> GeneralInformation?
}

extension GeneralInformationCreateServiceDeserializer: GeneralInformationCreateServiceDeserializerProtocol {}
