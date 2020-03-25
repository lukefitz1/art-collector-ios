//
//  GeneralInformationEditServiceSerializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/24/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

protocol GeneralInformationEditServiceSerializerProtocol {
    func serialize(infoLabel: String,
                   info: String,
                   createdAt: String,
                   updatedAt: String) -> Parameters
}

extension GeneralInformationEditServiceSerializer: GeneralInformationEditServiceSerializerProtocol {}

