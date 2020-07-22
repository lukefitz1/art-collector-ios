//
//  GeneralInformationServiceSpec.swift
//  Specs
//
//  Created by Luke Fitzgerald on 5/29/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Quick
import Nimble

@testable import art_collector_ios_dev

class GeneralInformationServiceSpec: QuickSpec {
    
    override func spec() {
        var subject: GeneralInformationService!

        beforeEach {
            subject = GeneralInformationService()
        }
        
        describe("first test") {
          it("should pass") {
            expect(1).to(equal(1))
          }
        }
    }
}
