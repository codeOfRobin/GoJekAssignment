//
//  ContactViewModel.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 04/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

struct ContactViewModel  {
	let firstName: String
	let lastName: String
	let email: String?
	let profilePic: URL?
	let favorite: Bool
}

extension ContactViewModel: Codable {
	enum CodingKeys: String, CodingKey {
		case firstName = "first_name"
		case lastName = "last_name"
		case email
		case profilePic = "profile_pic"
		case favorite
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		firstName = try values.decode(String.self, forKey: .firstName)
		lastName = try values.decode(String.self, forKey: .lastName)
		email = try? values.decode(String.self, forKey: .email)
		let profileURLString: String? = try? values.decode(String.self, forKey: .profilePic)
		profilePic = profileURLString.flatMap(URL.init)
		favorite = try values.decode(Bool.self, forKey: .favorite)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(firstName, forKey: .firstName)
		try container.encode(lastName, forKey: .lastName)
		try container.encode(email, forKey: .email)
		try container.encode(profilePic, forKey: .profilePic)
		try container.encode(favorite, forKey: .favorite)
	}
}
