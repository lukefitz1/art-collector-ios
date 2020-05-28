//
//  GetGeneralInformationServiceDeserializerSpec.swift
//  Specs
//
//  Created by Luke Fitzgerald on 5/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Quick
import Nimble

@testable import art_collector_ios

class GetGeneralInformationServiceDeserializerSpec: QuickSpec {
    
    override func spec() {
        var subject: GetGeneralInformationServiceDeserializer!

        beforeEach {
            subject = GetGeneralInformationServiceDeserializer()
        }

        describe("when deserializing valid JSON") {
            var fakeResponse: [String: Any]!
            var deserializedResponse: GeneralInformation!
            let generalInfo1 = GeneralInformation(
                id: "a28621d5-1111-2222-3333-3f45ca88d633",
                infoLabel: "Anatolian Rug",
                information: "This is some general information about Anatolian Rug",
                createdAt: "2020-04-04T21:20:44.651Z",
                updatedAt: "2020-04-04T21:20:44.651Z")

            beforeEach {
                fakeResponse = [
                    "id": "a28621d5-1111-2222-3333-3f45ca88d633",
                    "information_label": "Anatolian Rug",
                    "information": "This is some general information about Anatolian Rug",
                    "created_at": "2020-04-04T21:20:44.651Z",
                    "updated_at": "2020-04-04T21:20:44.651Z"
                ]
                deserializedResponse = subject.deserialize(response: fakeResponse as Any)
            }

            it("deserializes each item to match its JSON equivalent") {
                expect(deserializedResponse).to(equal(generalInfo1))
            }
        }

        describe("when deserializing invalid JSON") {
            var fakeResponse: [[String: Any]]!
            var deserializedResponse: GeneralInformation!

            beforeEach {
                fakeResponse = [["invalid": "stuff"]]
                deserializedResponse = subject.deserialize(response: fakeResponse as Any)
            }

            it("returns an empty response") {
                expect(deserializedResponse).to(beNil())
            }
        }

        describe("when deserializing JSON array of invalid elements") {
            var fakeResponse: [[String: Any]]!
            var deserializedResponse: GeneralInformation!

            beforeEach {
                fakeResponse = [
                    [
                        "test": "stuff",
                        "stuff": "test",
                        "invalid": "invalid data",
                        "attributes": "wrong attributes",
                        "done": "stuff",
                        "words": "wrong attributes",
                        "doing": "stuff"
                    ]
                ]
                deserializedResponse = subject.deserialize(response: fakeResponse as Any)
            }

            it("returns an empty response") {
                expect(deserializedResponse).to(beNil())
            }
        }
    }
}
