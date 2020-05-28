//
//  GeneralInformationServiceDeserializerSpec.swift
//  Specs
//
//  Created by Luke Fitzgerald on 5/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Quick
import Nimble

@testable import art_collector_ios

class GeneralInformationServiceDeserializerSpec: QuickSpec {
    
    override func spec() {
        var subject: GeneralInformationServiceDeserializer!

        beforeEach {
            subject = GeneralInformationServiceDeserializer()
        }
        
        describe("when deserializing valid JSON") {
            var fakeResponse: [[String: Any]]!
            var deserializedResponse: [GeneralInformation]!
            let generalInfo1 = GeneralInformation(id: "a28621d5-9e2c-4810-a1d4-3f45ca88d633", infoLabel: "Anatolian Rug", information: "This is some general information about Anatolian Rug", createdAt: "2020-04-04T21:20:44.651Z", updatedAt: "2020-04-04T21:20:44.651Z")
            let generalInfo2 = GeneralInformation(id: "a7713796-d134-46d7-b5cf-95a9438a5eba", infoLabel: "Art of Costa Rica", information: "This is some general information about Art of Costa Rica", createdAt: "2020-05-15T21:20:44.651Z", updatedAt: "2020-05-15T21:20:44.651Z")
            let generalInfo3 = GeneralInformation(id: "88b75556-aa75-4f9e-b350-c3ccc949844b", infoLabel: "Oriental Rugs", information: "This is some general information about Oriental Rugs", createdAt: "2020-03-03T21:20:44.651Z", updatedAt: "2020-03-03T21:20:44.651Z")

            beforeEach {
                fakeResponse = [
                    [
                        "id": "a28621d5-9e2c-4810-a1d4-3f45ca88d633",
                        "information_label": "Anatolian Rug",
                        "information": "This is some general information about Anatolian Rug",
                        "created_at": "2020-04-04T21:20:44.651Z",
                        "updated_at": "2020-04-04T21:20:44.651Z"
                    ],
                    [
                        "id": "a7713796-d134-46d7-b5cf-95a9438a5eba",
                        "information_label": "Art of Costa Rica",
                        "information": "This is some general information about Art of Costa Rica",
                        "created_at": "2020-05-15T21:20:44.651Z",
                        "updated_at": "2020-05-15T21:20:44.651Z"
                    ],
                    [
                        "id": "88b75556-aa75-4f9e-b350-c3ccc949844b",
                        "information_label": "Oriental Rugs",
                        "information": "This is some general information about Oriental Rugs",
                        "created_at": "2020-03-03T21:20:44.651Z",
                        "updated_at": "2020-03-03T21:20:44.651Z"
                    ]
                ]
                deserializedResponse = subject.deserialize(response: fakeResponse as Any)
            }

            it("deserializes each item in the JSON array") {
                expect(deserializedResponse.count).to(equal(3))
            }

            it("deserializes each item to match its JSON equivalent") {
                expect(deserializedResponse[0]).to(equal(generalInfo1))
                expect(deserializedResponse[1]).to(equal(generalInfo2))
                expect(deserializedResponse[2]).to(equal(generalInfo3))
            }
        }
        
        describe("when deserializing invalid JSON") {
            var fakeResponse: [[String: Any]]!
            var deserializedResponse: [GeneralInformation]!

            beforeEach {
                fakeResponse = [["invalid": "stuff"]]
                deserializedResponse = subject.deserialize(response: fakeResponse as Any)
            }

            it("returns an empty array") {
                expect(deserializedResponse).to(equal([]))
            }
        }

        describe("when deserializing JSON array of invalid elements") {
            var fakeResponse: [[String: Any]]!
            var deserializedResponse: [GeneralInformation]!

            beforeEach {
                fakeResponse = [
                    [
                        "test": "stuff",
                        "stuff": "test",
                        "invalid": "invalid data",
                        "attributes": "wrong attributes",
                        "done": "stuff"
                    ],
                    [
                        "id": "a28621d5-9e2c-4810-a1d4-3f45ca88d633",
                        "information_label": "Anatolian Rug",
                        "information": "This is some general information about Anatolian Rug",
                        "created_at": "2020-04-04T21:20:44.651Z",
                        "updated_at": "2020-04-04T21:20:44.651Z"
                    ]
                ]
                deserializedResponse = subject.deserialize(response: fakeResponse as Any)
            }

            it("returns an empty array") {
                expect(deserializedResponse).to(equal([]))
            }
        }
    }
}
