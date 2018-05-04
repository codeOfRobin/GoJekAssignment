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
		XCTAssertEqual(contactsRoute.path, "/contacts")

		let contactRoute = APIRequestBuilder.Route.contact(id: 123)
		XCTAssertEqual(contactRoute.path, "/contacts/123")
    }

	func testTaskPaths() {
		let task1 = APIRequestBuilder.Task.getContact(id: 123)
		XCTAssertEqual(task1.route.path, "/contacts/123")

		let vm = ContactViewModel(firstName: "Robin", lastName: "Malhotra", email: "me@rmalhotra.com", profilePic: nil, favorite: false)

		let task2 = APIRequestBuilder.Task.createContact(contact: APIRequestBuilder.ContactCreationModel(model: vm))
		XCTAssertEqual(task2.route.path, "/contacts")

		let task3 = APIRequestBuilder.Task.getContacts
		XCTAssertEqual(task3.route.path, "/contacts")

		let task4 = APIRequestBuilder.Task.updateContact(contact: APIRequestBuilder.ContactUpdatingModel(id: 123, model: vm))
		XCTAssertEqual(task4.route.path, "/contacts/123")

	}

	func testGetContactsTask() {
		let request = requestBuilder.request(for: .getContacts)
		XCTAssertEqual(request?.httpBody, nil)

		// This test felt a little too brittle since it depended on the pathComponents API which might change
		// XCTAssertEqual(request?.url?.pathComponents, ["/" ,"contacts"])
		// so instead we just check for the existence of contacts
		XCTAssertEqual(request?.url?.pathComponents.contains("contacts"), true)

		XCTAssertEqual(request?.httpMethod, "GET")
		XCTAssertNil(request?.httpBody)
	}
    
}
