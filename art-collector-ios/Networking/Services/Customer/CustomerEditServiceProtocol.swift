//
//  CustomerEditServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/2/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol CustomerEditServiceProtocol {
    func updateCustomer(id: String,
                        fName: String,
                        lName: String,
                        email: String,
                        phone: String,
                        address: String,
                        city: String,
                        state: String,
                        zip: String,
                        referredBy: String,
                        projectNotes: String,
                        createdAt: String,
                        updatedAt: String,
                        completionHandler: ((Customer?, Error?) -> Void)?)
}

extension CustomerEditService: CustomerEditServiceProtocol {}
