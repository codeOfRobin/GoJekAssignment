//
//  ContactUpdatingModel.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 05/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

extension APIRequestBuilder {
	// Explicitly kept separate from `ContactCreationModel` because they're separated by an ID. I'd wish Swift had structural sharing to solve this, but alas. I'd also try separating name, email etc into its own struct but that felt icky
	struct ContactUpdatingModel {
		let id: Int
		let model: Contact.Attributes
	}
}


extension APIRequestBuilder.ContactUpdatingModel: Encodable {
	enum CodingKeys: String, CodingKey {
		case firstName = "first_name"
		case lastName = "last_name"
		case email
		case profilePic = "profile_pic"
		case favorite
		case phoneNumber = "phone_number"
		case id
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(model.firstName, forKey: .firstName)
		try container.encode(model.lastName, forKey: .lastName)
		try container.encode(model.email, forKey: .email)
		try container.encode(model.profilePic, forKey: .profilePic)
		try container.encode(model.favorite, forKey: .favorite)
		try container.encode(model.phoneNumber, forKey: .phoneNumber)
	}
}
