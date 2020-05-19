//
//  GeneralInformationTransformer.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 5/16/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

class GeneralInformationTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        let stringArray = value as! [String]
        var uuidArray: [UUID] = []
        
        stringArray.forEach { (id) in
            print("Fuck: \(id)")
            uuidArray.append(UUID(uuidString: id)!)
        }
        
        return uuidArray as Any?
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        let uuidArray = value as! [UUID]
        var stringArray: [String] = []
        
        uuidArray.forEach { (id) in
            print("Fuck in reverse: \(id)")
            stringArray.append(id.uuidString)
        }
        
        return stringArray as Any?
    }
}

extension NSValueTransformerName {
    static let generalInfoTransformerName = NSValueTransformerName(rawValue: "GeneralInformationTransformer")
}
