//
//  ContactDecoderTests.swift
//  GoJekTakeHomeTests
//
//  Created by Robin Malhotra on 04/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import XCTest
@testable import GoJekTakeHome

class ContactDecoderTests: XCTestCase {

	let jsonDecoder = JSONDecoder()
    
    func testContactViewModel() {

		let jsonData = """
			[{
				"id": 1314,
				"first_name": "aaaaa",
				"last_name": "qqqqqqqqqqqqq",
				"email": "something@example.com",
				"profile_pic": "https://contacts-app.s3-ap-southeast-1.amazonaws.com/contacts/profile_pics/000/000/042/original/arrow_down.png?1494582973",
				"favorite": true,
				"url": "https://gojek-contacts-app.herokuapp.com/contacts/1314.json"
			},
			{
				"id": 1305,
				"first_name": "etseser",
				"last_name": "bbbbbbbb",
				"profile_pic": "/images/missing.png",
				"favorite": false,
				"url": "https://gojek-contacts-app.herokuapp.com/contacts/1305.json"
			}]
		""".data(using: .utf8)!

		do {
			let contacts = try jsonDecoder.decode(Array<ContactViewModel>.self, from: jsonData)
			XCTAssertEqual(contacts.count, 2)
			XCTAssertEqual(contacts[0].firstName, "aaaaa")
			XCTAssertEqual(contacts[1].lastName, "bbbbbbbb")
			XCTAssertEqual(contacts[0].email, "something@example.com")
			XCTAssertEqual(contacts[0].profilePic?.absoluteString, URL(string: "https://contacts-app.s3-ap-southeast-1.amazonaws.com/contacts/profile_pics/000/000/042/original/arrow_down.png?1494582973")!.absoluteString)
			XCTAssertEqual(contacts[0].favorite, true)

		} catch {
			XCTFail(error.localizedDescription)
		}


        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
