//
//  ArtistCreateServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/18/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol ArtistCreateServiceProtocol {
    func createArtist(id: String,
                      fName: String,
                      lName: String,
                      bio: String,
                      additionalInfo: String,
                      image: String,
                      createdAt: String,
                      updatedAt: String,
                      completionHandler: ((Artist?, Error?) -> Void)?)
}

extension ArtistCreateService: ArtistCreateServiceProtocol {}

