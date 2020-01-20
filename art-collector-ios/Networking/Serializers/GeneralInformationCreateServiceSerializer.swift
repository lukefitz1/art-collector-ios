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
    func serialize(infoLabel: String,
                   info: String) -> Parameters {
        
        let parameters: Parameters = [ "information_label": infoLabel,
                                       "information": info]
        
        return parameters
    }
}
