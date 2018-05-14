//
//  AllContactsListCoordinator.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 12/05/18.
//

import UIKit


class AllContactListCoordinator: Coordinator, ContactListDelegate {

	let rootViewController: UINavigationController
	var viewController:  ContactListViewController?

	let services: Services

	var addContactCoordinator: AddContactCoordinator?
	var contactDetailsCoordinator: ContactDetailsCoordinator?

	init(rootViewController: UINavigationController, services: Services) {
		self.rootViewController = rootViewController
		self.services = services
	}

	func didAskForNewContact(vc: ContactListViewController) {
		addContactCoordinator = AddContactCoordinator(rootViewController: rootViewController, services: services)
		addContactCoordinator?.delegate = self
		addContactCoordinator?.start()
	}

	func didAskForContactDetails(vc: ContactListViewController, contact: Contact) {
		contactDetailsCoordinator = ContactDetailsCoordinator(contact: contact, services: services, rootViewController: rootViewController)
		contactDetailsCoordinator?.delegate = self
		contactDetailsCoordinator?.start()
	}

	func start() {
		viewController = ContactListViewController.init(services: services)
		guard let vc = viewController else {
			fatalError(Constants.Strings.Errors.viewControllerInitialization)
		}
		self.rootViewController.viewControllers = [vc]
		vc.delegate = self
	}

}

extension AllContactListCoordinator: AddContactCoordinatorDelegate {
	func addContactCoordinatorDidRequestCancel(_ addContactCoordinator: AddContactCoordinator) {
		self.addContactCoordinator?.rootViewController.dismiss(animated: true, completion: nil)
		self.addContactCoordinator = nil
	}


	func addContactCoordinator(_ addContactCoordinator: AddContactCoordinator, didAddContact contact: Contact) {
		self.services.contacts.insert(contact)
		self.addContactCoordinator?.rootViewController.dismiss(animated: true, completion: nil)
		self.addContactCoordinator = nil
	}
}

extension AllContactListCoordinator: ContactDetailsCoordinatorDelegate {
	func userTappedBackButton(on coordinator: ContactDetailsCoordinator) {
		contactDetailsCoordinator = nil
	}
}
