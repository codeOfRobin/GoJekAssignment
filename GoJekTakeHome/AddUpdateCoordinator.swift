//
//  AddUpdateCoordinator.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 10/05/18.
//

import UIKit

protocol AddContactCoordinatorDelegate: class {
	func addContactCoordinatorDidRequestCancel(_ addContactCoordinator: AddContactCoordinator)
	func addContactCoordinator(_ addContactCoordinator: AddContactCoordinator, didAddContact contact: Contact)
}

class AddContactCoordinator: Coordinator, UpsertContactsViewControllerDelegate {

	let rootViewController: UINavigationController
	weak var delegate: AddContactCoordinatorDelegate?

	var viewController: UpsertContactsViewController?
	let services: Services

	init(rootViewController: UINavigationController, services: Services) {
		self.rootViewController = rootViewController
		self.services = services
	}

	func start() {
		let vc = UpsertContactsViewController(initialState: .add)
		viewController = vc
		let nav = UINavigationController(rootViewController: vc)

		nav.navigationBar.tintColor = Styles.Colors.tintColor
		vc.delegate = self
		rootViewController.present(nav, animated: true, completion: nil)
	}

	func cancelButtonTapped() {
		self.delegate?.addContactCoordinatorDidRequestCancel(self)
	}

	func saveButtonTapped(with attrs: Contact.Attributes) {
		services.apiClient.createContact(with: attrs) { (result) in
			switch result {
			case .success(let contact):
				self.delegate?.addContactCoordinator(self, didAddContact: contact)
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
}

