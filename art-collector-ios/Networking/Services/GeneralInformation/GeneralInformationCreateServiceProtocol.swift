//
//  GeneralInformationCreateServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/20/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol GeneralInformationCreateServiceProtocol {
    func createGeneralInformation(infoLabel: String,
                                  info: String,
                                  completionHandler: ((GeneralInformation?, Error?) -> Void)?)
}

extension GeneralInformationCreateService: GeneralInformationCreateServiceProtocol {}
