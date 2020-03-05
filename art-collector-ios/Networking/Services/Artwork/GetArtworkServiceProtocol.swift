//
//  GetArtworkServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol GetArtworkServiceProtocol {
    func getArtworkInfo(artworkId: String, completionHandler: ((Artwork?, Error?) -> Void)?)
}

extension GetArtworkService: GetArtworkServiceProtocol {}
