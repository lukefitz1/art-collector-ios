//
//  ArtistsTranformer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 5/16/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

class ArtistsTranformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        let array = value as! [String]
        return array
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        let array = value as! [String]
        return array
    }
}

extension NSValueTransformerName {
    static let artistsTransformerName = NSValueTransformerName(rawValue: "ArtistsTranformer")
}
