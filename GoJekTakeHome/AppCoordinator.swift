//
//  AppCoordinator.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 05/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

public struct Services {

	public let dataService: DataService

	public init() {
		self.dataService = DataService()
	}
}

public class DataService {

	var contacts = SortedArray<Contact>()
}


protocol Coordinator {
	func start()
}

// http://khanlou.com/2015/10/coordinators-redux/
class AppCoordinator: Coordinator {

	let allContactListCoordinator = AllContactListCoordinator()

	let rootViewController: UINavigationController
	let window: UIWindow

	init(window: UIWindow) {
		self.window = window
		rootViewController = UINavigationController()
		rootViewController.navigationBar.prefersLargeTitles = false

	}

	func start() {
	}
	
}

class ModifyContactCoordinator: Coordinator {
	func start() {

	}
}


protocol AddContactDelegate: class {
	func userDidAdd(_ contact: Contact)
}

class AddContactCoordinator: Coordinator {

	func start() {
		
	}

}

class ContactDetailCoordinator: Coordinator {

	var modifyContactCoordinator: ModifyContactCoordinator?

	func start() {

	}
}

class AllContactListCoordinator: Coordinator {

	let viewController = ContactListViewController()

	var addContactCoordinator: ModifyContactCoordinator?
	var contactDetailCoordinator: ModifyContactCoordinator?

	func start() {
	}

}
