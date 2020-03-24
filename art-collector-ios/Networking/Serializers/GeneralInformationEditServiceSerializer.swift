//
//  GeneralInformationEditServiceSerializer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/24/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct GeneralInformationEditServiceSerializer {
    func serialize(infoLabel: String,
                   info: String,
                   createdAt: String,
                   updatedAt: String) -> Parameters {
        
        let parameters: Parameters = [ "information_label": infoLabel,
                                       "information": info,
                                       "created_at": createdAt,
                                       "updated_at": updatedAt]
        
        return parameters
    }
}
