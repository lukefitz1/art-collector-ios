//
//  GetCustomerServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/9/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol GetCustomerServiceProtocol {
    func getCustomer(customerId: String, completionHandler: ((Customer?, Error?) -> Void)?)
}

extension GetCustomerService: GetCustomerServiceProtocol {}
