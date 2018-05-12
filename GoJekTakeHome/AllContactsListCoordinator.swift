//
//  AllContactsListCoordinator.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 12/05/18.
//

import UIKit


class AllContactListCoordinator: Coordinator, ContactListDelegate {

	let rootViewController: UINavigationController

	let viewController = ContactListViewController()

	var addContactCoordinator: AddContactCoordinator?
	var contactDetailsCoordinator: ContactDetailsCoordinator?

	init(rootViewController: UINavigationController) {
		self.rootViewController = rootViewController
	}

	func didAskForNewContact(vc: ContactListViewController) {
		addContactCoordinator = AddContactCoordinator(rootViewController: rootViewController)
		addContactCoordinator?.delegate = self
		addContactCoordinator?.start()
	}

	func didAskForContactDetails(vc: ContactListViewController, contact: Contact) {
		contactDetailsCoordinator = ContactDetailsCoordinator(contact: contact, rootViewController: rootViewController)
		
		contactDetailsCoordinator?.start()
	}

	func start() {
		let contactsListViewController = ContactListViewController()
		self.rootViewController.viewControllers = [contactsListViewController]
		contactsListViewController.delegate = self
	}

}

extension AllContactListCoordinator: AddContactCoordinatorDelegate {
	func addContactCoordinatorDidRequestCancel(_ addContactCoordinator: AddContactCoordinator) {
		self.addContactCoordinator?.rootViewController.dismiss(animated: true, completion: nil)
	}


	func addContactCoordinator(_ addContactCoordinator: AddContactCoordinator, didAddContact contactPayload: Contact.Attributes) {

	}
}
