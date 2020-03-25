//
//  ArtistEditServiceSerializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/25/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

protocol ArtistEditServiceSerializerProtocol {
    func serialize(firstName: String,
                   lastName: String,
                   additionalInfo: String,
                   biography: String,
                   artistImage: String,
                   createdAt: String,
                   updatedAt: String) -> Parameters
}

extension ArtistEditServiceSerializer: ArtistEditServiceSerializerProtocol {}
