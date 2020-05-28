//
//  ArtworksServiceDeserializerSpec.swift
//  Specs
//
//  Created by Luke Fitzgerald on 5/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Quick
import Nimble

@testable import art_collector_ios

class ArtworksServiceDeserializerSpec: QuickSpec {
    
    override func spec() {
        var subject: ArtworksServiceDeserializer!

        beforeEach {
            subject = ArtworksServiceDeserializer()
        }
        
        describe("when deserializing valid JSON") {
            var fakeResponse: [[String: Any]]!
            var deserializedResponse: [Artwork]!
            
            let artwork1 = Artwork(
                id: "51d7074c-2525-497d-be59-f48846123456",
                objectId: "TST.101",
                artType: "Painting",
                title: "Art 1 Title",
                date: "2019",
                medium: "Paper",
                image: Image(
                    url: "https://website.com/painting.jpg",
                    thumb: ThumbImage(url: "https://website.com/thumb_painting.jpg")),
                description: "Test description",
                dimensions: "25x27",
                frameDimensions: "26x28",
                condition: "Perfect",
                currentLocation: "Kitchen",
                source: "Tim Hussey",
                dateAcquired: "2020",
                amountPaid: "1200",
                currentValue: "1500",
                notes: "These are some notes",
                notesImage: Image(
                    url: "https://website.com/notes_painting.jpg",
                    thumb: ThumbImage(url: "https://website.com/thumb_notes_painting.jpg")),
                additionalInfoLabel: "",
                additionalInfoText: "Gold wood frame",
                additionalInfoImage: Image(
                    url: "https://website.com/add_info_painting.jpg",
                    thumb: ThumbImage(url: "https://website.com/thumb_add_info_painting.jpg")),
                additionalPdf: Pdf(url: ""),
                reviewedBy: "Dianne",
                reviewedDate: "2020",
                provenance: "Living Room",
                dateAcquiredLabel: "Date Acquired",
                collectionId: "51d7074c-2525-497d-be59-f48846ea3214",
                customerId: "5432127d-4322-43d9-a7ae-7213e22b150a",
                notesImageTwo: Image(
                    url: "",
                    thumb: ThumbImage(url: "")),
                additionalInfoImageTwo: Image(
                    url: "",
                    thumb: ThumbImage(url: "")),
                showGeneralInfo: false,
                customTitle: "",
                createdAt: "2020-01-01T21:20:44.651Z",
                updatedAt: "2020-01-01T21:20:44.651Z",
                artistId: "",
                generalInfoId: "",
                artistIds: [""],
                generalInfoIds: [""])
            
            let artwork2 = Artwork(
                id: "51d7074c-5432-497d-be59-f48846123456",
                objectId: "TST.102",
                artType: "Painting",
                title: "Art 2 Title",
                date: "2019",
                medium: "Paper",
                image: Image(
                    url: "https://website.com/painting.jpg",
                    thumb: ThumbImage(url: "https://website.com/thumb_painting.jpg")),
                description: "Test description",
                dimensions: "25x27",
                frameDimensions: "26x28",
                condition: "Perfect",
                currentLocation: "Kitchen",
                source: "Tim Hussey",
                dateAcquired: "2020",
                amountPaid: "1200",
                currentValue: "1500",
                notes: "These are some notes",
                notesImage: Image(
                    url: "https://website.com/notes_painting.jpg",
                    thumb: ThumbImage(url: "https://website.com/thumb_notes_painting.jpg")),
                additionalInfoLabel: "",
                additionalInfoText: "Gold wood frame",
                additionalInfoImage: Image(
                    url: "https://website.com/add_info_painting.jpg",
                    thumb: ThumbImage(url: "https://website.com/thumb_add_info_painting.jpg")),
                additionalPdf: Pdf(url: ""),
                reviewedBy: "Dianne",
                reviewedDate: "2020",
                provenance: "Living Room",
                dateAcquiredLabel: "Date Acquired",
                collectionId: "51d7074c-2525-497d-be59-f48846ea3214",
                customerId: "5432127d-4322-43d9-a7ae-7213e22b150a",
                notesImageTwo: Image(
                    url: "",
                    thumb: ThumbImage(url: "")),
                additionalInfoImageTwo: Image(
                    url: "",
                    thumb: ThumbImage(url: "")),
                showGeneralInfo: false,
                customTitle: "",
                createdAt: "2020-01-01T21:20:44.651Z",
                updatedAt: "2020-01-01T21:20:44.651Z",
                artistId: "",
                generalInfoId: "",
                artistIds: [""],
                generalInfoIds: [""])
            
            let artwork3 = Artwork(
                id: "51d7074c-1234-497d-be59-f48846123456",
                objectId: "TST.103",
                artType: "Painting",
                title: "Art 3 Title",
                date: "2019",
                medium: "Paper",
                image: Image(
                    url: "https://website.com/painting.jpg",
                    thumb: ThumbImage(url: "https://website.com/thumb_painting.jpg")),
                description: "Test description",
                dimensions: "25x27",
                frameDimensions: "26x28",
                condition: "Perfect",
                currentLocation: "Kitchen",
                source: "Tim Hussey",
                dateAcquired: "2020",
                amountPaid: "1200",
                currentValue: "1500",
                notes: "These are some notes",
                notesImage: Image(
                    url: "https://website.com/notes_painting.jpg",
                    thumb: ThumbImage(url: "https://website.com/thumb_notes_painting.jpg")),
                additionalInfoLabel: "",
                additionalInfoText: "Gold wood frame",
                additionalInfoImage: Image(
                    url: "https://website.com/add_info_painting.jpg",
                    thumb: ThumbImage(url: "https://website.com/thumb_add_info_painting.jpg")),
                additionalPdf: Pdf(url: ""),
                reviewedBy: "Dianne",
                reviewedDate: "2020",
                provenance: "Living Room",
                dateAcquiredLabel: "Date Acquired",
                collectionId: "51d7074c-2525-497d-be59-f48846ea3214",
                customerId: "5432127d-4322-43d9-a7ae-7213e22b150a",
                notesImageTwo: Image(
                    url: "",
                    thumb: ThumbImage(url: "")),
                additionalInfoImageTwo: Image(
                    url: "",
                    thumb: ThumbImage(url: "")),
                showGeneralInfo: false,
                customTitle: "",
                createdAt: "2020-01-01T21:20:44.651Z",
                updatedAt: "2020-01-01T21:20:44.651Z",
                artistId: "",
                generalInfoId: "",
                artistIds: [""],
                generalInfoIds: [""])
            
            beforeEach {
                fakeResponse = [
                    [
                        "id": "51d7074c-2525-497d-be59-f48846123456",
                        "ojbId": "TST.101",
                        "artType": "Painting",
                        "title": "Art 1 Title",
                        "date": "2019",
                        "medium": "Paper",
                        "image": [
                            "url": "https://website.com/painting.jpg",
                            "thumb": ["url": "https://website.com/thumb_painting.jpg"]],
                        "description": "Test description",
                        "dimensions": "25x27",
                        "frame_dimensions": "26x28",
                        "condition": "Perfect",
                        "currentLocation": "Kitchen",
                        "source": "Tim Hussey",
                        "dateAcquired": "2020",
                        "amountPaid": "1200",
                        "currentValue": "1500",
                        "notes": "These are some notes",
                        "notesImage": [
                            "url": "https://website.com/notes_painting.jpg",
                            "thumb": ["url": "https://website.com/thumb_notes_painting.jpg"]],
                        "additionalInfoLabel": "",
                        "additionalInfoText": "Gold wood frame",
                        "additionalInfoImage": [
                            "url": "https://website.com/add_info_painting.jpg",
                            "thumb": ["url": "https://website.com/thumb_add_info_painting.jpg"]],
                        "additionalPdf": ["url": ""],
                        "reviewedBy": "Dianne",
                        "reviewedDate": "2020",
                        "provenance": "Living Room",
                        "dateAcquiredLabel": "Date Acquired",
                        "collection_id": "51d7074c-2525-497d-be59-f48846ea3214",
                        "customer_id": "5432127d-4322-43d9-a7ae-7213e22b150a",
                        "notesImageTwo": [
                            "url": "",
                            "thumb": ["url": ""]],
                        "additionalInfoImageTwo": [
                            "url": "",
                            "thumb": ["url": ""]],
                        "show_general_info": false,
                        "custom_title": "",
                        "created_at": "2020-01-01T21:20:44.651Z",
                        "updated_at": "2020-01-01T21:20:44.651Z",
                        "artist_id": "",
                        "general_information_id": "",
                        "artist_ids": [""],
                        "general_information_ids": [""]
                    ],
                    [
                        "id": "51d7074c-5432-497d-be59-f48846123456",
                        "ojbId": "TST.102",
                        "artType": "Painting",
                        "title": "Art 2 Title",
                        "date": "2019",
                        "medium": "Paper",
                        "image": [
                            "url": "https://website.com/painting.jpg",
                            "thumb": ["url": "https://website.com/thumb_painting.jpg"]],
                        "description": "Test description",
                        "dimensions": "25x27",
                        "frame_dimensions": "26x28",
                        "condition": "Perfect",
                        "currentLocation": "Kitchen",
                        "source": "Tim Hussey",
                        "dateAcquired": "2020",
                        "amountPaid": "1200",
                        "currentValue": "1500",
                        "notes": "These are some notes",
                        "notesImage": [
                            "url": "https://website.com/notes_painting.jpg",
                            "thumb": ["url": "https://website.com/thumb_notes_painting.jpg"]],
                        "additionalInfoLabel": "",
                        "additionalInfoText": "Gold wood frame",
                        "additionalInfoImage": [
                            "url": "https://website.com/add_info_painting.jpg",
                            "thumb": ["url": "https://website.com/thumb_add_info_painting.jpg"]],
                        "additionalPdf": ["url": ""],
                        "reviewedBy": "Dianne",
                        "reviewedDate": "2020",
                        "provenance": "Living Room",
                        "dateAcquiredLabel": "Date Acquired",
                        "collection_id": "51d7074c-2525-497d-be59-f48846ea3214",
                        "customer_id": "5432127d-4322-43d9-a7ae-7213e22b150a",
                        "notesImageTwo": [
                            "url": "",
                            "thumb": ["url": ""]],
                        "additionalInfoImageTwo": [
                            "url": "",
                            "thumb": ["url": ""]],
                        "show_general_info": false,
                        "custom_title": "",
                        "created_at": "2020-01-01T21:20:44.651Z",
                        "updated_at": "2020-01-01T21:20:44.651Z",
                        "artist_id": "",
                        "general_information_id": "",
                        "artist_ids": [""],
                        "general_information_ids": [""]
                    ],
                    [
                        "id": "51d7074c-1234-497d-be59-f48846123456",
                        "ojbId": "TST.103",
                        "artType": "Painting",
                        "title": "Art 3 Title",
                        "date": "2019",
                        "medium": "Paper",
                        "image": [
                            "url": "https://website.com/painting.jpg",
                            "thumb": ["url": "https://website.com/thumb_painting.jpg"]],
                        "description": "Test description",
                        "dimensions": "25x27",
                        "frame_dimensions": "26x28",
                        "condition": "Perfect",
                        "currentLocation": "Kitchen",
                        "source": "Tim Hussey",
                        "dateAcquired": "2020",
                        "amountPaid": "1200",
                        "currentValue": "1500",
                        "notes": "These are some notes",
                        "notesImage": [
                            "url": "https://website.com/notes_painting.jpg",
                            "thumb": ["url": "https://website.com/thumb_notes_painting.jpg"]],
                        "additionalInfoLabel": "",
                        "additionalInfoText": "Gold wood frame",
                        "additionalInfoImage": [
                            "url": "https://website.com/add_info_painting.jpg",
                            "thumb": ["url": "https://website.com/thumb_add_info_painting.jpg"]],
                        "additionalPdf": ["url": ""],
                        "reviewedBy": "Dianne",
                        "reviewedDate": "2020",
                        "provenance": "Living Room",
                        "dateAcquiredLabel": "Date Acquired",
                        "collection_id": "51d7074c-2525-497d-be59-f48846ea3214",
                        "customer_id": "5432127d-4322-43d9-a7ae-7213e22b150a",
                        "notesImageTwo": [
                            "url": "",
                            "thumb": ["url": ""]],
                        "additionalInfoImageTwo": [
                            "url": "",
                            "thumb": ["url": ""]],
                        "show_general_info": false,
                        "custom_title": "",
                        "created_at": "2020-01-01T21:20:44.651Z",
                        "updated_at": "2020-01-01T21:20:44.651Z",
                        "artist_id": "",
                        "general_information_id": "",
                        "artist_ids": [""],
                        "general_information_ids": [""]
                    ]
                ]
                
                deserializedResponse = subject.deserialize(response: fakeResponse as Any)
            }
            
            it("deserializes each item in the JSON array") {
                expect(deserializedResponse.count).to(equal(3))
            }

            it("deserializes each item to match its JSON equivalent") {
                expect(deserializedResponse[0]).to(equal(artwork1))
                expect(deserializedResponse[1]).to(equal(artwork2))
                expect(deserializedResponse[2]).to(equal(artwork3))
            }
        }
        
        describe("when deserializing invalid JSON") {
            var fakeResponse: [[String: Any]]!
            var deserializedResponse: [Artwork]!

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
            var deserializedResponse: [Artwork]!

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
                        "collectionName": "ART COLLECTION",
                        "artworks": [],
                        "identifier": "SIEGFRIED",
                        "customer_id": "189ea27d-77a6-43d9-a7ae-7213e22b150a",
                        "created_at": "2019-01-28T15:09:01.916Z",
                        "updated_at": "2019-01-28T22:47:28.864Z",
                        "year": "2020",
                        "customer": [
                            "id": "189ea27d-77a6-43d9-a7ae-7213e22b150a",
                            "created_at": "2019-01-27T15:09:33.150Z",
                            "updated_at": "2019-01-27T15:09:33.150Z",
                            "firstName": "Anne",
                            "lastName": "Siegfried",
                            "email_address": "test",
                            "phone_number": "test",
                            "street_address": "test",
                            "city": "test",
                            "state": "test",
                            "zip": "test",
                            "referred_by": "test",
                            "project_notes": "test"
                        ]
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
