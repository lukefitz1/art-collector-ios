//
//  ArtworkCreateServiceDeserializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/30/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol ArtworkCreateServiceDeserializerProtocol {
    func deserialize(response: Any) -> Artwork?
}

extension ArtworkCreateServiceDeserializer: ArtworkCreateServiceDeserializerProtocol {}
