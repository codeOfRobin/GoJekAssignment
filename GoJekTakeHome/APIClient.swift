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
				return "/\(Constants.contactsPath)/\(id)"
			case .contacts:
				return "/\(Constants.contactsPath)"
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
			return nil
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

		return request
	}
}


extension APIRequestBuilder {
	struct ContactCreationModel {
		let model: ContactViewModel
	}

	// explicitly kept separate from `ContactCreationModel` because they're separated by an ID. I'd wish Swift had structural sharing to solve this, but alas. I'd also try separating name, email etc into its own struct but that felt icky
	struct ContactUpdatingModel {
		let id: Int
		let model: ContactViewModel
	}
}

struct ContactViewModel {
	let firstName: String
	let lastName: String
	let email: String
	let profile_pic: URL?
	let favorite: Bool
}

struct Contact {
	let model: ContactViewModel
	let id: Int
	let createdAt: Date
	let updatedAt: Date
}
