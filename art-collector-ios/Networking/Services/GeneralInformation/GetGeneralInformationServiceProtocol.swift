//
//  GetGeneralInformationServiceProtocol.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation

protocol GetGeneralInformationServiceProtocol {
    func getGeneralInfo(giId: String, completionHandler: ((GeneralInformation?, Error?) -> Void)?)
}

extension GetGeneralInformationService: GetGeneralInformationServiceProtocol {}
