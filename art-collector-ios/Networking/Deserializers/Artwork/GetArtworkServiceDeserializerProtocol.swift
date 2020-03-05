//
//  GetArtworkServiceDeserializerProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol GetArtworkServiceDeserializerProtocol {
    func deserialize(response: Any) -> Artwork?
}

extension GetArtworkServiceDeserializer: GetArtworkServiceDeserializerProtocol {}
