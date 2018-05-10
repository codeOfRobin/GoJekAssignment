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

	let allContactListCoordinator: AllContactListCoordinator

	let rootViewController: UINavigationController = {
		let nav = UINavigationController()
		nav.navigationBar.prefersLargeTitles = false
		return nav
	}()

	let window: UIWindow

	init(window: UIWindow) {
		self.window = window

		self.window.rootViewController = rootViewController
		self.window.makeKeyAndVisible()

		self.allContactListCoordinator = AllContactListCoordinator(rootViewController: rootViewController)

		rootViewController.navigationBar.tintColor = Styles.Colors.tintColor
	}

	func start() {
		allContactListCoordinator.start()
	}

}


class AddContactCoordinator: Coordinator {

	func start() {
		
	}

}

class ContactDetailCoordinator: Coordinator {

	func start() {

	}
}

class AllContactListCoordinator: Coordinator, ContactListDelegate {

	let rootViewController: UINavigationController

	init(rootViewController: UINavigationController) {
		self.rootViewController = rootViewController
	}

	func didAskForNewContact(vc: ContactListViewController) {
		addUpdateContactCoordinator = AddUpdateContactCoordinator.init(rootViewController: rootViewController)
		addUpdateContactCoordinator?.delegate = self
		addUpdateContactCoordinator?.start()
	}

	func didAskForContactDetails(vc: ContactListViewController, contact: Contact) {
		let vc = ContactDetailsViewController(contact: contact)
		rootViewController.pushViewController(vc, animated: true)
	}


	let viewController = ContactListViewController()

	var addUpdateContactCoordinator: AddUpdateContactCoordinator?
	var contactDetailCoordinator: ContactDetailCoordinator?

	func start() {
		let contactsListViewController = ContactListViewController()
		self.rootViewController.viewControllers = [contactsListViewController]
		contactsListViewController.delegate = self
	}

}

extension AllContactListCoordinator: AddUpdateContactCoordinatorDelegate {
	func addUpdateContactCoordinatorDidRequestCancel(_ addUpdateContactCoordinator: AddUpdateContactCoordinator) {
		self.addUpdateContactCoordinator?.rootViewController.dismiss(animated: true, completion: nil)
	}

	func addUpdateContactCoordinator(_ addUpdateContactCoordinator: AddUpdateContactCoordinator, didAddContact contactPayload: Contact.Attributes) {

	}

	func addUpdateContactCoordinator(_ addUpdateContactCoordinator: AddUpdateContactCoordinator, didUpdateContact contactPayload: Contact) {

	}


}
