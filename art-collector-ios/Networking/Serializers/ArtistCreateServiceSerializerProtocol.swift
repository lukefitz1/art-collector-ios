//
//  ArtistCreateServiceSerializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/18/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

protocol ArtistCreateServiceSerializerProtocol {
    func serialize(firstName: String,
                   lastName: String,
                   additionalInfo: String,
                   biography: String,
                   artistImage: String) -> Parameters
}

extension ArtistCreateServiceSerializer: ArtistCreateServiceSerializerProtocol {}
