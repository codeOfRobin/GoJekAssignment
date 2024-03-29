//
//  ContactEncoderTests.swift
//  GoJekTakeHomeTests
//
//  Created by Robin Malhotra on 05/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import XCTest
@testable import GoJekTakeHome

class ContactEncoderTests: XCTestCase {
    
    func testContactCreationEncoding() {

		let creationModel = APIRequestBuilder.ContactCreationModel(model: Contact.Attributes(firstName: "Robin", lastName: "Malhotra", email: nil, phoneNumber: nil, profilePic: nil, favorite: true))

		do {
			let encoder = JSONEncoder()
			let data = try encoder.encode(creationModel)
			// We could also test the string that's generated, but that would be a brittle test that would fail depending on changes in the API(because of things like whitespace). I'd rather test that JSON with the correct keys was generated for the backend to consume
			let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]

			XCTAssertEqual(json["first_name"] as? String, "Robin")
			XCTAssertEqual(json["last_name"] as? String, "Malhotra")
			XCTAssertEqual(json["email"] as? String, nil)
			XCTAssertEqual(json["favorite"] as? Bool, true)

		} catch {
			XCTFail(error.localizedDescription)
		}
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

	func testContactUpdatingEncoding() {
		let updatingModel = APIRequestBuilder.ContactUpdatingModel(id: 123, model: Contact.Attributes(firstName: "Robin", lastName: "Malhotra", email: "something@example.com", phoneNumber: "123123", profilePic: nil, favorite: false))

		do {
			let encoder = JSONEncoder()
			let data = try encoder.encode(updatingModel)

			let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]

			XCTAssertEqual(json["first_name"] as? String, "Robin")
			XCTAssertEqual(json["last_name"] as? String, "Malhotra")
			XCTAssertEqual(json["email"] as? String, "something@example.com")
			XCTAssertEqual(json["phone_number"] as? String, "123123")
			XCTAssertEqual(json["favorite"] as? Bool, false)
		} catch {
			XCTFail(error.localizedDescription)
		}

	}
    
}
