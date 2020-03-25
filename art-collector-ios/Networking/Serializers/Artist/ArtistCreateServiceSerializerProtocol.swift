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
    func serialize(id: String,
                   firstName: String,
                   lastName: String,
                   additionalInfo: String,
                   biography: String,
                   artistImage: String,
                   createdAt: String,
                   updatedAt: String) -> Parameters
}

extension ArtistCreateServiceSerializer: ArtistCreateServiceSerializerProtocol {}
