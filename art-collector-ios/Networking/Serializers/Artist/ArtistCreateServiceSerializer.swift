//
//  ArtistCreateServiceSerializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/18/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct ArtistCreateServiceSerializer {
    func serialize(id: String,
                   firstName: String,
                   lastName: String,
                   additionalInfo: String,
                   biography: String,
                   artistImage: String,
                   createdAt: String,
                   updatedAt: String) -> Parameters {
        
        let parameters: Parameters = [ "id": id,
                                       "firstName": firstName,
                                       "lastName": lastName,
                                       "biography": biography,
                                       "additionalInfo": additionalInfo,
                                       "artist_image": artistImage,
                                       "created_at": createdAt,
                                       "updated_at": updatedAt ]
        
        return parameters
    }
}
