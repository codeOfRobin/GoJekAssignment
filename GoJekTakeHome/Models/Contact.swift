//
//  Contact.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 04/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

struct Contact {
	let model: Attributes
	let id: Int
	let createdAt: Date?
	let updatedAt: Date?
}

extension Contact: Decodable {
	enum CodingKeys: String, CodingKey {
		case id
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)
		let singleValue = try decoder.singleValueContainer()
		id = try values.decode(Int.self, forKey: .id)
		createdAt = try? values.decode(Date.self, forKey: .createdAt)
		updatedAt = try? values.decode(Date.self, forKey: .updatedAt)
		model = try singleValue.decode(Attributes.self)
	}

}
