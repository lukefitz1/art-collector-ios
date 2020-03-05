//
//  GetGeneralInformationServiceDeserializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol GetGeneralInformationServiceDeserializerProtocol {
    func deserialize(response: Any) -> GeneralInformation?
}

extension GetGeneralInformationServiceDeserializer: GetGeneralInformationServiceDeserializerProtocol {}
