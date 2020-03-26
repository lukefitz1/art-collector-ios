//
//  AddressUtility.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/26/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

struct AddressUtility {
    static func getFormattedAddressTwo(customer: CustomerCore) -> String {
        let city = customer.city
        let state = customer.state
        let zip = customer.zip
        
        if city != "" && state != "" && zip != "" {
            if let city = city {
                if let state = state {
                    if let zip = zip {
                        return "\(city), \(state) \(zip)"
                    }
                }
            }
        }
        
        if city != "" && state != "" {
            if let city = city {
                if let state = state {
                    return "\(city), \(state)"
                }
            }
        }
        
        if state != "" && zip != "" {
            if let state = state {
                if let zip = zip {
                    return "\(state) \(zip)"
                }
            }
        }
        
        if city != "" && zip != "" {
            if let city = city {
                if let zip = zip {
                    return "\(city) \(zip)"
                }
            }
        }
        
        if let zip = zip {
            return "\(zip)"
        }
        
        return ""
    }
}
