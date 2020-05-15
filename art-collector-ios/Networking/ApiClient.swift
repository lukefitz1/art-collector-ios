//
//  ApiClient.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/27/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct ApiClient {
    static let baseUrl = "https://spire-art-services.herokuapp.com/api/"
    static var accessToken: String = ""
    static var tokenType: String = ""
    static var client: String = ""
    static var expiry: String = ""
    static var uid: String = ""
}
