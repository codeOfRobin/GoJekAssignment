//
//  ContactAttributes.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 04/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

extension Contact {

	struct Attributes  {
		let firstName: String
		let lastName: String
		let email: String?
		let phoneNumber: String?
		// TODO: turn this into an `Avatar` type
		let profilePic: URL?
		let favorite: Bool

		var name: String {
			return [firstName, lastName].joined(separator: " ")
		}
	}
}

extension Contact.Attributes: Decodable {
	enum CodingKeys: String, CodingKey {
		case firstName = "first_name"
		case lastName = "last_name"
		case email
		case profilePic = "profile_pic"
		case favorite
		case phoneNumber = "phone_number"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		firstName = try values.decode(String.self, forKey: .firstName)
		lastName = try values.decode(String.self, forKey: .lastName)
		email = try? values.decode(String.self, forKey: .email)
		let profileURLString: String? = try? values.decode(String.self, forKey: .profilePic)
		// Bad API design 🤬. This should be a nil regardless and not a relative URL.
		if profileURLString == "/images/missing.png" {
			profilePic = nil
		} else {
			profilePic = profileURLString.flatMap(URL.init)
		}
		favorite = try values.decode(Bool.self, forKey: .favorite)
		phoneNumber = try? values.decode(String.self, forKey: .phoneNumber)
	}
}
