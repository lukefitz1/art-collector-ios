//
//  ArtistsServiceDeserializerSpec.swift
//  Specs
//
//  Created by Luke Fitzgerald on 5/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Quick
import Nimble

@testable import art_collector_ios_dev

class ArtistsServiceDeserializerSpec: QuickSpec {
    
    override func spec() {
        var subject: ArtistsServiceDeserializer!

        beforeEach {
            subject = ArtistsServiceDeserializer()
        }
        
        describe("when deserializing valid JSON") {
            var fakeResponse: [[String: Any]]!
            var deserializedResponse: [Artist]!
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
            let artist2 = Artist(
                id: "a7713796-2222-46d7-b5cf-95a9438a5eba",
                firstName: "Jordy",
                lastName: "Nelson",
                biography: "French artist, Jordy Nelson was a painter known for his still-life’s and flowers. Born in Paris, he was a student of Pierre-Marie Beyle (1837-1902).  Nelson’s painting, Chrysanthemums, is in the collection of the Musée de Sète.",
                additionalInfo: "USA, b. 1987",
                artistImage: Image(
                    url: "https://website.com/jordy_nelson.jpg",
                    thumb: ThumbImage(url: "https://website.com/thumb_jordy_nelson.jpg")),
                createdAt: "2020-05-05T21:20:44.651Z",
                updatedAt: "2020-05-05T21:20:44.651Z")
            let artist3 = Artist(
                id: "88b75556-3333-4f9e-b350-c3ccc949844b",
                firstName: "Davante",
                lastName: "Adams",
                biography: "Born in Santa Fe, a descendant of generations of New Mexico ranchers, the brilliant hues and stark contrasts of the American Southwest inspired artist Davante Adams from an early age. Interests in drawing, photography, weaving, and ceramics further developed Adams's commitment to artistically portraying light. A four-year journey through Europe’s museums and studios, followed by a ten-year stint studying in New York City art academies, while simultaneously teaching others and maintaining his own studio, firmly planted Mr. Adams on his artistic path. His beloved Sangre de Cristo mountains called Davante back to Santa Fe.",
                additionalInfo: "USA, b. 1986",
                artistImage: Image(
                    url: "https://website.com/davante_adams.jpg",
                    thumb: ThumbImage(url: "https://website.com/thumb_davante_adams.jpg")),
                createdAt: "2020-03-03T21:20:44.651Z",
                updatedAt: "2020-03-03T21:20:44.651Z")

            beforeEach {
                fakeResponse = [
                    [
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
                    ],
                    [
                        "id": "a7713796-2222-46d7-b5cf-95a9438a5eba",
                        "firstName": "Jordy",
                        "lastName": "Nelson",
                        "biography": "French artist, Jordy Nelson was a painter known for his still-life’s and flowers. Born in Paris, he was a student of Pierre-Marie Beyle (1837-1902).  Nelson’s painting, Chrysanthemums, is in the collection of the Musée de Sète.",
                        "additionalInfo": "USA, b. 1987",
                        "created_at": "2020-05-05T21:20:44.651Z",
                        "updated_at": "2020-05-05T21:20:44.651Z",
                        "artist_image": [
                            "url": "https://website.com/jordy_nelson.jpg",
                            "thumb": [
                                "url": "https://website.com/thumb_jordy_nelson.jpg"
                            ]
                        ]
                    ],
                    [
                        "id": "88b75556-3333-4f9e-b350-c3ccc949844b",
                        "firstName": "Davante",
                        "lastName": "Adams",
                        "biography": "Born in Santa Fe, a descendant of generations of New Mexico ranchers, the brilliant hues and stark contrasts of the American Southwest inspired artist Davante Adams from an early age. Interests in drawing, photography, weaving, and ceramics further developed Adams's commitment to artistically portraying light. A four-year journey through Europe’s museums and studios, followed by a ten-year stint studying in New York City art academies, while simultaneously teaching others and maintaining his own studio, firmly planted Mr. Adams on his artistic path. His beloved Sangre de Cristo mountains called Davante back to Santa Fe.",
                        "additionalInfo": "USA, b. 1986",
                        "created_at": "2020-03-03T21:20:44.651Z",
                        "updated_at": "2020-03-03T21:20:44.651Z",
                        "artist_image": [
                            "url": "https://website.com/davante_adams.jpg",
                            "thumb": [
                                "url": "https://website.com/thumb_davante_adams.jpg"
                            ]
                        ]
                    ]
                ]
                deserializedResponse = subject.deserialize(response: fakeResponse as Any)
            }

            it("deserializes each item in the JSON array") {
                expect(deserializedResponse.count).to(equal(3))
            }

            it("deserializes each item to match its JSON equivalent") {
                expect(deserializedResponse[0]).to(equal(artist1))
                expect(deserializedResponse[1]).to(equal(artist2))
                expect(deserializedResponse[2]).to(equal(artist3))
            }
        }
        
        describe("when deserializing invalid JSON") {
            var fakeResponse: [[String: Any]]!
            var deserializedResponse: [Artist]!

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
            var deserializedResponse: [Artist]!

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
                        "firstName": "Davante",
                        "lastName": "Adams",
                        "biography": "Born in Santa Fe, a descendant of generations of New Mexico ranchers, the brilliant hues and stark contrasts of the American Southwest inspired artist Davante Adams from an early age. Interests in drawing, photography, weaving, and ceramics further developed Adams's commitment to artistically portraying light. A four-year journey through Europe’s museums and studios, followed by a ten-year stint studying in New York City art academies, while simultaneously teaching others and maintaining his own studio, firmly planted Mr. Adams on his artistic path. His beloved Sangre de Cristo mountains called Davante back to Santa Fe.",
                        "additionalInfo": "USA, b. 1986",
                        "created_at": "2020-03-03T21:20:44.651Z",
                        "updated_at": "2020-03-03T21:20:44.651Z",
                        "artist_image": [
                            "url": "https://website.com/davante_adams.jpg",
                            "thumb": [
                                "url": "https://website.com/thumb_davante_adams.jpg"
                            ]
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
