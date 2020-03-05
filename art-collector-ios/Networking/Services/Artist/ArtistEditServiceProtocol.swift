//
//  ArtistEditServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol ArtistEditServiceProtocol {
    func updateArtist(id: String,
                      fName: String,
                      lName: String,
                      bio: String,
                      additionalInfo: String,
                      image: String,
                      completionHandler: ((Artist?, Error?) -> Void)?)
}

extension ArtistEditService: ArtistEditServiceProtocol {}
