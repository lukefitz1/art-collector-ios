//
//  CustomersServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 12/30/19.
//  Copyright © 2019 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol CustomersServiceProtocol {
    func getCustomers(completionHandler: (([Customer]?, Error?) -> Void)?)
}

extension CustomersService: CustomersServiceProtocol {}
