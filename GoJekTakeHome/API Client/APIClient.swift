//
//  APIClient.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 04/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

enum Result<T> {
	case success(T)
	case failure(Error)
}

class APIClient {
	let session: URLSession
	let requestBuilder = APIRequestBuilder()

	struct ContactsRequestError: Codable {
		let errors: [String]
	}

	enum APIError: Error {
		case requestCreationFailed
		case urlSessionError(NSError)
		case dataIsNil
		case requestFailed(ContactsRequestError)
		case decodingError(DecodingError)

		var localizedDescription: String {
			switch self {
			case .dataIsNil:
				return Constants.Strings.Errors.dataIsNil
			case .decodingError:
				return Constants.Strings.Errors.clientSideError
			case .requestCreationFailed:
				return Constants.Strings.Errors.clientSideError
			case .requestFailed(let apiError):
				return apiError.errors.first ?? ""
			case .urlSessionError(let nsErrror):
				return nsErrror.localizedDescription
			}
		}
	}

	init(session: URLSession = .shared) {
		self.session = session
	}

	@discardableResult private func performRequest<T: Decodable>(request: URLRequest, for: T.Type, onComplete completion: @escaping (Result<T>) -> Void ) -> URLSessionDataTask {
//		print(String.init(data: request.httpBody!, encoding: .utf8))
		let task = session.dataTask(with: request) { (data, response, error) in
			if let nsError = error as NSError? {
				DispatchQueue.main.sync {
					completion(.failure(APIError.urlSessionError(nsError)))
				}
				return
			}

			guard let data = data, let httpResponse = response as? HTTPURLResponse else {
				DispatchQueue.main.sync {
					completion(.failure(APIError.dataIsNil))
				}
				return
			}

			let jsonDecoder = JSONDecoder()

			guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
				do {
					let requestError = try jsonDecoder.decode(ContactsRequestError.self, from: data)
					completion(.failure(APIError.requestFailed(requestError)))
				} catch {
					if let decodingError = error as? DecodingError {
						DispatchQueue.main.sync {
							completion(.failure(APIError.decodingError(decodingError)))
						}
					} else {
						// You could make this fail as a `randomError` or something, but I don't like having undefined cases in my API. Better to fail first and fail fast usually
						fatalError()
					}
				}
				return
			}

			do {
				let value = try jsonDecoder.decode(T.self, from: data)
				DispatchQueue.main.sync {
					completion(.success(value))
				}
			} catch {
				if let decodingError = error as? DecodingError {
					DispatchQueue.main.sync {
						completion(.failure(APIError.decodingError(decodingError)))
					}
				} else {
					// You could make this fail as a `randomError` or something, but I don't like having undefined cases in my API. Better to fail first and fail fast usually
					fatalError()
				}
			}
		}
		task.resume()
		return task
	}

	@discardableResult func createContact(with attributes: Contact.Attributes, onComplete completion: @escaping (Result<Contact>) -> Void) -> URLSessionDataTask? {
		let creationModel = APIRequestBuilder.ContactCreationModel(model: attributes)
		guard let request = requestBuilder.request(for: .createContact(contact: creationModel)) else {
			completion(.failure(APIError.requestCreationFailed))
			return nil
		}

		let task = self.performRequest(request: request, for: Contact.self) { (result) in
			completion(result)
		}
		return task
	}

	@discardableResult func updateContact(with contact: Contact, onComplete completion: @escaping (Result<Contact>) -> Void) -> URLSessionDataTask? {
		let updateModel = APIRequestBuilder.ContactUpdatingModel(id: contact.id, model: contact.model)
		guard let request = requestBuilder.request(for: .updateContact(contact: updateModel)) else {
			completion(.failure(APIError.requestCreationFailed))
			return nil
		}

		let task = self.performRequest(request: request, for: Contact.self) { (result) in
			completion(result)
		}
		return task
	}

	@discardableResult func getContacts(onComplete completion: @escaping (Result<[Contact]>) -> Void) -> URLSessionDataTask? {
		guard let request = requestBuilder.request(for: .getContacts) else {
			completion(.failure(APIError.requestCreationFailed))
			return nil
		}

		let task = self.performRequest(request: request, for: [Contact].self) { (result) in
			completion(result)
		}
		return task
	}

	@discardableResult func getContact(with id: Int, onComplete completion: @escaping (Result<Contact>) -> Void) -> URLSessionDataTask? {
		guard let request = requestBuilder.request(for: .getContact(id: id)) else {
			completion(.failure(APIError.requestCreationFailed))
			return nil
		}

		let task = self.performRequest(request: request, for: Contact.self) { (result) in
			completion(result)
		}
		return task
	}

	@discardableResult func setFavoriteState(_ state: Bool, of contact: Contact, onComplete completion: @escaping (Result<Contact>) -> Void) -> URLSessionDataTask? {
		let model = contact.model
		let attrs = Contact.Attributes.init(firstName: model.firstName, lastName: model.lastName, email: model.email, phoneNumber: model.phoneNumber, profilePic: model.profilePic, favorite: state)
		let updateModel = APIRequestBuilder.ContactUpdatingModel.init(id: contact.id, model: attrs)
		guard let request = requestBuilder.request(for: .updateContact(contact: updateModel)) else {
			completion(.failure(APIError.requestCreationFailed))
			return nil
		}

		let task = self.performRequest(request: request, for: Contact.self) { (result) in
			completion(result)
		}
		return task
	}
}

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

		request.addValue("application/json", forHTTPHeaderField: "Content-Type")

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

