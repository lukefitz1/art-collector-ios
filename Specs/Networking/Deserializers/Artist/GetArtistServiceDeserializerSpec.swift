//
//  GetArtistServiceDeserializerSpec.swift
//  Specs
//
//  Created by Luke Fitzgerald on 5/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Quick
import Nimble

@testable import art_collector_ios

class GetArtistServiceDeserializerSpec: QuickSpec {
    
    override func spec() {
        var subject: GetArtistServiceDeserializer!

        beforeEach {
            subject = GetArtistServiceDeserializer()
        }
        
        describe("when deserializing valid JSON") {
            var fakeResponse: [String: Any]!
            var deserializedResponse: Artist!
            let artist1 = Artist(
                id: "a28621d5-1111-4810-a1d4-3f45ca88d633",
                firstName: "Aaron",
                lastName: "Rodgers",
                biography: "Known for a range of work in watercolor and gouache that included realist figures in cityscapes, landscapes, and trompe l'oeil painting, Aaron Rodgers spent his early career in Chicago where he studied at the Art Institute of Chicago and then went to New York City to attend the Art Students League. He returned to his hometown in 1930 and resided there until he moved to Wisconsin in 1948, and became a long-time faculty member of the University of Wisconsin art department. Influenced strongly by the Social Realism of John Sloan, whom he knew from New York, Rodgers painted city people, utilizing a wide array of styles ranging from a tight, detailed manner to more abstract and sketch like.  One of his subjects was the neighborhood where he grew up on the North Side of Chicago.",
                additionalInfo: "USA, b. 1988",
                artistImage: Image(
                    url: "https://website.com/aaron_rodgers.jpg",
                    thumb: ThumbImage(url: "https://website.com/thumb_aaron_rodgers.jpg")),
                createdAt: "2020-04-04T21:20:44.651Z",
                updatedAt: "2020-04-04T21:20:44.651Z")
            
            beforeEach {
                fakeResponse = [
                    "id": "a28621d5-1111-4810-a1d4-3f45ca88d633",
                    "firstName": "Aaron",
                    "lastName": "Rodgers",
                    "biography": "Known for a range of work in watercolor and gouache that included realist figures in cityscapes, landscapes, and trompe l'oeil painting, Aaron Rodgers spent his early career in Chicago where he studied at the Art Institute of Chicago and then went to New York City to attend the Art Students League. He returned to his hometown in 1930 and resided there until he moved to Wisconsin in 1948, and became a long-time faculty member of the University of Wisconsin art department. Influenced strongly by the Social Realism of John Sloan, whom he knew from New York, Rodgers painted city people, utilizing a wide array of styles ranging from a tight, detailed manner to more abstract and sketch like.  One of his subjects was the neighborhood where he grew up on the North Side of Chicago.",
                    "additionalInfo": "USA, b. 1988",
                    "created_at": "2020-04-04T21:20:44.651Z",
                    "updated_at": "2020-04-04T21:20:44.651Z",
                    "artist_image": [
                        "url": "https://website.com/aaron_rodgers.jpg",
                        "thumb": [
                            "url": "https://website.com/thumb_aaron_rodgers.jpg"
                        ]
                    ]
                ]
                deserializedResponse = subject.deserialize(response: fakeResponse as Any)
            }

            it("deserializes each item to match its JSON equivalent") {
                expect(deserializedResponse).to(equal(artist1))
            }
        }
        
        describe("when deserializing invalid JSON") {
            var fakeResponse: [[String: Any]]!
            var deserializedResponse: Artist!

            beforeEach {
                fakeResponse = [["invalid": "stuff"]]
                deserializedResponse = subject.deserialize(response: fakeResponse as Any)
            }

            it("returns an empty response") {
                expect(deserializedResponse).to(beNil())
            }
        }

        describe("when deserializing JSON array of invalid elements") {
            var fakeResponse: [String: Any]!
            var deserializedResponse: Artist!

            beforeEach {
                fakeResponse = [
                    "test": "111121d5-1111-4810-a1d4-3f45ca88d633",
                    "foo": "bar",
                    "bar": "foo",
                    "wrong": "Known for a range of work",
                    "attributes": "USA, b. 1988",
                    "stuff": "2020-04-04T21:20:44.651Z",
                    "more_stuff": "2020-04-04T21:20:44.651Z",
                    "what": [
                        "url": "https://website.com/aaron_rodgers.jpg",
                        "thumb": [
                            "url": "https://website.com/thumb_aaron_rodgers.jpg"
                        ]
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
