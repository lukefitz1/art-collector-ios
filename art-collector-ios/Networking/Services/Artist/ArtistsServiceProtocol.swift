//
//  ArtistsServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol ArtistsServiceProtocol {
    func getArtists(completionHandler: (([Artist]?, Error?) -> Void)?)
}

extension ArtistsService: ArtistsServiceProtocol {}
