//
//  ContactCreationModel.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 05/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation


extension APIRequestBuilder {
	struct ContactCreationModel {
		let model: Contact.Attributes
		// add any extra contact creation info here
	}
}

extension APIRequestBuilder.ContactCreationModel: Encodable {

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: Contact.Attributes.CodingKeys.self)
		try container.encode(model.firstName, forKey: .firstName)
		try container.encode(model.lastName, forKey: .lastName)
		try container.encode(model.email, forKey: .email)
		try container.encode(model.profilePic, forKey: .profilePic)
		try container.encode(model.favorite, forKey: .favorite)
	}
}
