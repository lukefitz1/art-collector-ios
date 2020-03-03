//
//  GeneralInformationServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol GeneralInformationServiceProtocol {
    func getGeneralInformation(completionHandler: (([GeneralInformation]?, Error?) -> Void)?)
}

extension GeneralInformationService: GeneralInformationServiceProtocol {}
