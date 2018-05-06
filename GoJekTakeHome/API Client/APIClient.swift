//
//  APIClient.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 04/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

class APIRequestBuilder {
	enum Constants {
		static let host = "gojek-contacts-app.herokuapp.com"
		static let scheme = "https"
		static let contactsPath = "contacts"
	}

	enum Route {
		case contacts
		case contact(id: Int)

		// Computed variable are preferred to functions when there're no arguments
		var path: String {
			switch self {
			case .contact(let id):
				return "/\(Constants.contactsPath)/\(id).json"
			case .contacts:
				return "/\(Constants.contactsPath).json"
			}
		}
	}

	enum Task {
		case getContacts
		case getContact(id: Int)
		case createContact(contact: ContactCreationModel)
		case updateContact(contact: ContactUpdatingModel)

		// Computed variable are preferred to functions when there're no arguments
		var route: Route {
			switch self {
			case .createContact, .getContacts:
				return .contacts
			case .getContact(let id):
				return .contact(id: id)
			case .updateContact(let updateModel):
				return .contact(id: updateModel.id)
			}
		}
	}

	func request(for task: Task) -> URLRequest? {
		var components = URLComponents()
		components.scheme = Constants.scheme
		components.host = Constants.host

		let path = task.route.path
		components.path = path

		guard let url = components.url else {
			fatalError("Can't generate URL")
		}

		var request = URLRequest.init(url: url)

		request.httpMethod = {
			switch task {
			case .getContacts, .getContact:
				return "GET"
			case .updateContact:
				return "PUT"
			case .createContact:
				return "POST"
			}
		}()

		request.httpBody = {
			switch task {
			case .getContacts, .getContact:
				return nil
			case .createContact(let contact):
				let jsonEncoder = JSONEncoder()
				do {
					return try jsonEncoder.encode(contact)
				} catch {
					// if you can't encode JSON, you have bigger problems
					fatalError("Encoding failed")
				}
			case .updateContact(let contact):
				let jsonEncoder = JSONEncoder()
				do {
					return try jsonEncoder.encode(contact)
				} catch {
					// if you can't encode JSON, you have bigger problems
					fatalError("Encoding failed")
				}
			}
		}()

		return request
	}
}

