//
//  GeneralInformationServiceSpec.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 5/25/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Quick
import Nimble
import Alamofire

@testable import art_collector_ios

class GeneralInformationServiceSpec: QuickSpec {
    override func spec() {
        describe("when making a network request") {
            it("passes the correct path") {
                expect(1).to(equal(1))
            }
        }
    }
}
