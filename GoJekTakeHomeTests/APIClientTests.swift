//
//  APIClientTests.swift
//  GoJekTakeHomeTests
//
//  Created by Robin Malhotra on 04/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import XCTest
@testable import GoJekTakeHome

class APIClientTests: XCTestCase {

	let requestBuilder = APIRequestBuilder()

    func testPaths() {
		let contactsRoute = APIRequestBuilder.Route.contacts
		XCTAssertEqual(contactsRoute.path, "/contacts.json")

		let contactRoute = APIRequestBuilder.Route.contact(id: 123)
		XCTAssertEqual(contactRoute.path, "/contacts/123.json")
    }

	func testTaskPaths() {
		let task1 = APIRequestBuilder.Task.getContact(id: 123)
		XCTAssertEqual(task1.route.path, "/contacts/123.json")

		let vm = Contact.Attributes(firstName: "Robin", lastName: "Malhotra", email: "me@rmalhotra.com", phoneNumber: nil, profilePic: nil, favorite: false)

		let task2 = APIRequestBuilder.Task.createContact(contact: APIRequestBuilder.ContactCreationModel(model: vm))
		XCTAssertEqual(task2.route.path, "/contacts.json")

		let task3 = APIRequestBuilder.Task.getContacts
		XCTAssertEqual(task3.route.path, "/contacts.json")

		let task4 = APIRequestBuilder.Task.updateContact(contact: APIRequestBuilder.ContactUpdatingModel(id: 123, model: vm))
		XCTAssertEqual(task4.route.path, "/contacts/123.json")

	}

	func testGetContactsTask() {
		let request = requestBuilder.request(for: .getContacts)
		XCTAssertEqual(request?.httpBody, nil)

		// This test felt a little too brittle since it depended on the pathComponents API which might change
		// XCTAssertEqual(request?.url?.pathComponents, ["/" ,"contacts"])
		// so instead we just check for the existence of contacts
		XCTAssertEqual(request?.url?.pathComponents.contains("contacts.json"), true)
		// Not using XCTAssertTrue cos that requires unwrapping an optional 🤮

		XCTAssertEqual(request?.httpMethod, "GET")
		XCTAssertNil(request?.httpBody)
	}

	func testGetContactTask() {
		let request = requestBuilder.request(for: .getContact(id: 123))
		XCTAssertEqual(request?.url?.pathComponents.contains("contacts"), true)
		XCTAssertEqual(request?.url?.pathComponents.contains("123.json"), true)

		XCTAssertEqual(request?.httpMethod, "GET")
		XCTAssertNil(request?.httpBody)
	}

	func testCreateContactTask() {
		let model = Contact.Attributes.init(firstName: "Robin", lastName: "Malhotra", email: "something@example.com", phoneNumber: "123123", profilePic: URL(string: "https://something.com")!, favorite: true)
		let contact = APIRequestBuilder.ContactCreationModel(model: model)
		let request = requestBuilder.request(for: .createContact(contact: contact))

		do {
			let jsonFromBody = try JSONSerialization.jsonObject(with: (request!.httpBody)!, options: .allowFragments) as! [String: Any]

			XCTAssertEqual(jsonFromBody["first_name"] as? String, "Robin")
			XCTAssertEqual(jsonFromBody["last_name"] as? String, "Malhotra")
			XCTAssertEqual(jsonFromBody["phone_number"] as? String, "123123")
			XCTAssertEqual(jsonFromBody["email"] as? String, "something@example.com")
			XCTAssertEqual(jsonFromBody["favorite"] as? Bool, true)
			XCTAssertEqual(jsonFromBody["profile_pic"] as? String, "https://something.com")
		} catch {
			XCTFail(error.localizedDescription)
		}
	}


	func testUpdateContactTask() {
		let model = Contact.Attributes(firstName: "Robin", lastName: "Malhotra", email: "something@example.com", phoneNumber: "123123", profilePic: URL(string: "https://something.com")!, favorite: true)
		let contact = APIRequestBuilder.ContactUpdatingModel.init(id: 123, model: model)
		let request = requestBuilder.request(for: .updateContact(contact: contact))

		do {
			let jsonFromBody = try JSONSerialization.jsonObject(with: (request!.httpBody)!, options: .allowFragments) as! [String: Any]

			XCTAssertEqual(jsonFromBody["id"] as? Int, 123)
			XCTAssertEqual(jsonFromBody["first_name"] as? String, "Robin")
			XCTAssertEqual(jsonFromBody["last_name"] as? String, "Malhotra")
			XCTAssertEqual(jsonFromBody["phone_number"] as? String, "123123")
			XCTAssertEqual(jsonFromBody["email"] as? String, "something@example.com")
			XCTAssertEqual(jsonFromBody["favorite"] as? Bool, true)
			XCTAssertEqual(jsonFromBody["profile_pic"] as? String, "https://something.com")
		} catch {
			XCTFail(error.localizedDescription)
		}
	}
    
}
