//
//  GeneralInformationCreateServiceSerializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/20/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

protocol GeneralInformationCreateServiceSerializerProtocol {
    func serialize(id: String,
                   infoLabel: String,
                   info: String,
                   createdAt: String,
                   updatedAt: String) -> Parameters
}

extension GeneralInformationCreateServiceSerializer: GeneralInformationCreateServiceSerializerProtocol {}
