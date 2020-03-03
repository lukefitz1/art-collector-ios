//
//  CustomerCreateServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol CustomerCreateServiceProtocol {
    func createCustomer(fName: String,
                      lName: String,
                      email: String,
                      phone: String,
                      address: String,
                      city: String,
                      state: String,
                      zip: String,
                      referredBy: String,
                      projectNotes: String,
                      completionHandler: ((Customer?, Error?) -> Void)?)
}

extension CustomerCreateService: CustomerCreateServiceProtocol {}
