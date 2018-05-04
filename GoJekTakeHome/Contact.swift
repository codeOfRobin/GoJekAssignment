//
//  Contact.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 04/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import Foundation

struct Contact {
	let model: ContactViewModel
	let id: Int
	let createdAt: Date
	let updatedAt: Date
}

extension Contact: Codable {
	
}
