//
//  GeneralInformationEditServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol GeneralInformationEditServiceProtocol {
    func updateGeneralInformation(id: String,
                                  infoLabel: String,
                                  info: String,
                                  createdAt: String,
                                  updatedAt: String,
                                  completionHandler: ((GeneralInformation?, Error?) -> Void)?)
}

extension GeneralInformationEditService: GeneralInformationEditServiceProtocol {}
