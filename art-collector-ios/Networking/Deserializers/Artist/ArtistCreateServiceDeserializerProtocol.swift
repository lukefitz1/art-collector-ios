//
//  ArtistCreateServiceDeserializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/18/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol ArtistCreateServiceDeserializerProtocol {
    func deserialize(response: Any) -> Artist?
}

extension ArtistCreateServiceDeserializer: ArtistCreateServiceDeserializerProtocol {}
