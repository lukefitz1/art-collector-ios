//
//  GetArtistServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol GetArtistServiceProtocol {
    func getArtistInfo(artistId: String, completionHandler: ((Artist?, Error?) -> Void)?)
}

extension GetArtistService: GetArtistServiceProtocol {}
