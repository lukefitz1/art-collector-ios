//
//  GeneralInformationCreateServiceSerializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/20/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct GeneralInformationCreateServiceSerializer {
    func serialize(id: String,
                   infoLabel: String,
                   info: String,
                   createdAt: String,
                   updatedAt: String) -> Parameters {
        
        let parameters: Parameters = [ "id": id,
                                       "information_label": infoLabel,
                                       "information": info,
                                       "created_at": createdAt,
                                       "updated_at": updatedAt]
        
        return parameters
    }
}
