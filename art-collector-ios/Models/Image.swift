//
//  Image.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/3/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct Image: Decodable, Equatable {
    let url: String?
    let thumb: ThumbImage?
}

struct ThumbImage: Decodable, Equatable {
    let url: String?
}
