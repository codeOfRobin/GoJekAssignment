//
//  UpdateContactCoordinator.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 12/05/18.
//

import UIKit

protocol UpdateContactCoordinatorDelegate: class {
	func updateContactCoordinator(_ updateContactCoordinator: UpdateContactCoordinator, didUpdateContact contact: Contact)
	func updateContactCoordinatorDidRequestCancel(_ updateContactCoordinator: UpdateContactCoordinator)
}

class UpdateContactCoordinator: Coordinator, UpsertContactsViewControllerDelegate {
	weak var delegate: UpdateContactCoordinatorDelegate?

	var viewController: UINavigationController?

	let rootViewController: UINavigationController
	let contact: Contact
	let services: Services

	init(rootViewController: UINavigationController, contact: Contact, services: Services) {
		self.contact = contact
		self.services = services
		self.rootViewController = rootViewController
	}

	func start() {
		let vc = UpsertContactsViewController(initialState: .update(contact))

		viewController = UINavigationController(rootViewController: vc)

		guard let nav = viewController else {
			return
		}

		nav.navigationBar.tintColor = Styles.Colors.tintColor
		vc.delegate = self
		rootViewController.present(nav, animated: true, completion: nil)
	}

	func cancelButtonTapped() {
		viewController?.dismiss(animated: true, completion: nil)
		self.delegate?.updateContactCoordinatorDidRequestCancel(self)
	}

	func saveButtonTapped(with attrs: Contact.Attributes) {
		let newContact = Contact.init(model: attrs, id: contact.id, createdAt: nil, updatedAt: nil)
		self.services.apiClient.updateContact(with: newContact) { (result) in
			switch result {
			case .success(let contact):
				self.delegate?.updateContactCoordinator(self, didUpdateContact: contact)
			case .failure(let error):
				print(error)
			}
		}
	}
}
