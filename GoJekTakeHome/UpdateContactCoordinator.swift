//
//  UpdateContactCoordinator.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 12/05/18.
//

import UIKit

protocol UpdateContactCoordinatorDelegate: class {
	func updateContactCoordinator(_ updateContactCoordinator: UpdateContactCoordinator, didUpdateContact contactPayload: Contact)
	func updateContactCoordinatorDidRequestCancel(_ updateContactCoordinator: UpdateContactCoordinator)
}

class UpdateContactCoordinator: Coordinator, UpsertContactsViewControllerDelegate {
	weak var delegate: UpdateContactCoordinatorDelegate?

	let rootViewController: UINavigationController
	let contact: Contact

	init(rootViewController: UINavigationController, contact: Contact) {
		self.contact = contact
		self.rootViewController = rootViewController
	}

	func start() {
		let vc = UpsertContactsViewController(initialState: .update(contact))
		let nav = UINavigationController(rootViewController: vc)

		nav.navigationBar.tintColor = Styles.Colors.tintColor
		vc.delegate = self
		rootViewController.present(nav, animated: true, completion: nil)
	}

	func cancelButtonTapped() {
		self.delegate?.updateContactCoordinatorDidRequestCancel(self)
	}

	func saveButtonTapped(with contact: Contact) {
		self.delegate?.updateContactCoordinatorDidRequestCancel(self)
	}
}
