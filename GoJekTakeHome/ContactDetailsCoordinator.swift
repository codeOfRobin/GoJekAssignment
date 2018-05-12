//
//  ContactDetailsCoordinator.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 12/05/18.
//

import UIKit

class ContactDetailsCoordinator: Coordinator, ContactDetailsViewControllerDelegate {

	let rootViewController: UINavigationController
	let contact: Contact

	var viewController: ContactDetailsViewController?
	var updateContactCoordinator: UpdateContactCoordinator?

	init(contact: Contact, rootViewController: UINavigationController) {
		self.contact = contact
		self.rootViewController = rootViewController
	}

	func start() {
		viewController = ContactDetailsViewController.init(contact: contact)
		guard let vc = viewController else {
			//TODO: Add error messages for these common cases (vc initialization, dequeuing using Constants.swift
			fatalError()
		}
		vc.delegate = self
		rootViewController.pushViewController(vc, animated: true)
	}

	func editButtonTapped(_ vc: ContactDetailsViewController, contact: Contact) {
		updateContactCoordinator = UpdateContactCoordinator(rootViewController: self.rootViewController, contact: contact)
		guard let coordinator = updateContactCoordinator else {
			//TODO: Add error messages for these common cases (vc initialization, dequeuing using Constants.swift
			fatalError()
		}
		coordinator.start()
	}
}
