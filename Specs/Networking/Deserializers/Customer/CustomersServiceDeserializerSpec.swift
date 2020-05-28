//
//  CustomersServiceDeserializerSpec.swift
//  Specs
//
//  Created by Luke Fitzgerald on 5/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Quick
import Nimble

@testable import art_collector_ios

class CustomersServiceDeserializerSpec: QuickSpec {
    
    override func spec() {
        var subject: CustomersServiceDeserializer!

        beforeEach {
            subject = CustomersServiceDeserializer()
        }
        
        describe("when deserializing valid JSON") {
            var fakeResponse: [[String: Any]]!
            var deserializedResponse: [Customer]!
            
            let collection1 = Collection(
                id: "51d7074c-b4fd-497d-be59-f48846ea3214",
                collectionName: "ART COLLECTION - Denver",
                identifier: "DEN",
                year: "2019",
                artworks: [],
                customerId: "a28621d5-9e2c-4810-a1d4-3f45ca88d633",
                createdAt: "2019-01-28T15:09:01.916Z",
                updatedAt: "2019-01-28T15:09:01.916Z")

            let collection2 = Collection(
                id: "e46f0ac4-d022-4e00-9aba-3618e686d618",
                collectionName: "ART COLLECTION - Topeka",
                identifier: "TOP",
                year: "2020",
                artworks: [],
                customerId: "a7713796-d134-46d7-b5cf-95a9438a5eba",
                createdAt: "2019-01-28T15:09:01.916Z",
                updatedAt: "2019-01-28T15:09:01.916Z")

            let collection3 = Collection(
                id: "189ea27d-77a6-43d9-a7ae-7213e22b150a",
                collectionName: "ART COLLECTION - Nashville",
                identifier: "NASH",
                year: "2018",
                artworks: [],
                customerId: "a7713796-d134-46d7-b5cf-95a9438a5eba",
                createdAt: "2018-01-04T13:57:17.167Z",
                updatedAt: "2018-01-04T13:57:17.167Z")
            
            let customer1 = Customer(
                id: "a28621d5-9e2c-4810-a1d4-3f45ca88d633",
                firstName: "Bill",
                lastName: "Self",
                city: "Lawrence",
                state: "KS",
                zip: "66612",
                address: "1234 Main St",
                phone: "1234567890",
                email: "bill.self@ku.com",
                collections: [collection1],
                createdAt: "2020-04-04T21:20:44.651Z",
                updatedAt: "2020-04-04T21:20:44.651Z")
            
            let customer2 = Customer(
                id: "a7713796-d134-46d7-b5cf-95a9438a5eba",
                firstName: "Roy",
                lastName: "Williams",
                city: "Chapel Hill",
                state: "NC",
                zip: "27514",
                address: "4321 Main St",
                phone: "0987654321",
                email: "roy.williams@unc.com",
                collections: [collection2, collection3],
                createdAt: "2020-05-05T21:20:44.651Z",
                updatedAt: "2020-05-05T21:20:44.651Z")
            
            let customer3 = Customer(
                id: "88b75556-aa75-4f9e-b350-c3ccc949844b",
                firstName: "John",
                lastName: "Calipari",
                city: "Lexington",
                state: "KY",
                zip: "40502",
                address: "5555 Main St",
                phone: "4567890123",
                email: "john.calipari@uk.com",
                collections: [],
                createdAt: "2020-03-03T21:20:44.651Z",
                updatedAt: "2020-03-03T21:20:44.651Z")

            beforeEach {
                fakeResponse = [
                    [
                        "id": "a28621d5-9e2c-4810-a1d4-3f45ca88d633",
                        "created_at": "2020-04-04T21:20:44.651Z",
                        "updated_at": "2020-04-04T21:20:44.651Z",
                        "firstName": "Bill",
                        "lastName": "Self",
                        "email_address": "bill.self@ku.com",
                        "phone_number": "1234567890",
                        "street_address": "1234 Main St",
                        "city": "Lawrence",
                        "state": "KS",
                        "zip": "66612",
                        "collections": [
                            [ "id": "51d7074c-b4fd-497d-be59-f48846ea3214",
                                "created_at": "2019-01-28T15:09:01.916Z",
                                "updated_at": "2019-01-28T15:09:01.916Z",
                                "collectionName": "ART COLLECTION - Denver",
                                "identifier": "DEN",
                                "year": "2019",
                                "customer_id": "a28621d5-9e2c-4810-a1d4-3f45ca88d633",
                                "artworks": []]
                        ]
                    ],
                    [
                        "id": "a7713796-d134-46d7-b5cf-95a9438a5eba",
                        "created_at": "2020-05-05T21:20:44.651Z",
                        "updated_at": "2020-05-05T21:20:44.651Z",
                        "firstName": "Roy",
                        "lastName": "Williams",
                        "email_address": "roy.williams@unc.com",
                        "phone_number": "0987654321",
                        "street_address": "4321 Main St",
                        "city": "Chapel Hill",
                        "state": "NC",
                        "zip": "27514",
                        "collections": [
                            [ "id": "e46f0ac4-d022-4e00-9aba-3618e686d618",
                              "created_at": "2019-01-28T15:09:01.916Z",
                              "updated_at": "2019-01-28T15:09:01.916Z",
                              "collectionName": "ART COLLECTION - Topeka",
                              "identifier": "TOP",
                              "year": "2020",
                              "customer_id": "a7713796-d134-46d7-b5cf-95a9438a5eba",
                              "artworks": []],
                            [ "id": "189ea27d-77a6-43d9-a7ae-7213e22b150a",
                              "created_at": "2018-01-04T13:57:17.167Z",
                              "updated_at": "2018-01-04T13:57:17.167Z",
                              "collectionName": "ART COLLECTION - Nashville",
                              "identifier": "NASH",
                              "year": "2018",
                              "customer_id": "a7713796-d134-46d7-b5cf-95a9438a5eba",
                              "artworks": []]
                        ]
                    ],
                    [
                        "id": "88b75556-aa75-4f9e-b350-c3ccc949844b",
                        "created_at": "2020-03-03T21:20:44.651Z",
                        "updated_at": "2020-03-03T21:20:44.651Z",
                        "firstName": "John",
                        "lastName": "Calipari",
                        "email_address": "john.calipari@uk.com",
                        "phone_number": "4567890123",
                        "street_address": "5555 Main St",
                        "city": "Lexington",
                        "state": "KY",
                        "zip": "40502",
                        "collections": []
                    ]
                ]
                deserializedResponse = subject.deserialize(response: fakeResponse as Any)
            }

            it("deserializes each item in the JSON array") {
                expect(deserializedResponse.count).to(equal(3))
            }

            it("deserializes each item to match its JSON equivalent") {
                expect(deserializedResponse[0]).to(equal(customer1))
                expect(deserializedResponse[1]).to(equal(customer2))
                expect(deserializedResponse[2]).to(equal(customer3))
            }
        }
        
        describe("when deserializing invalid JSON") {
            var fakeResponse: [[String: Any]]!
            var deserializedResponse: [Customer]!

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
            var deserializedResponse: [Customer]!

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
                    ],
                    [
                        "id": "88b75556-aa75-4f9e-b350-c3ccc949844b",
                        "created_at": "2020-03-03T21:20:44.651Z",
                        "updated_at": "2020-03-03T21:20:44.651Z",
                        "firstName": "John",
                        "lastName": "Calipari",
                        "email_address": "john.calipari@uk.com",
                        "phone_number": "4567890123",
                        "street_address": "5555 Main St",
                        "city": "Lexington",
                        "state": "KY",
                        "zip": "40502",
                        "collections": []
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
