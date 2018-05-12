//
//  AddUpdateCoordinator.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 10/05/18.
//

import UIKit

protocol AddContactCoordinatorDelegate: class {
	func addContactCoordinatorDidRequestCancel(_ addContactCoordinator: AddContactCoordinator)
	func addContactCoordinator(_ addContactCoordinator: AddContactCoordinator, didAddContact contactPayload: Contact.Attributes)
}

class AddContactCoordinator: Coordinator, UpsertContactsViewControllerDelegate {

	let rootViewController: UINavigationController
	weak var delegate: AddContactCoordinatorDelegate?

	var viewController: UpsertContactsViewController?

	init(rootViewController: UINavigationController) {
		self.rootViewController = rootViewController
	}

	func start() {
		viewController = UpsertContactsViewController(initialState: .add)

		guard let vc = viewController else {
			// This means the initialization in 27 failed somehow, which would be a compiler bug or something
			fatalError()
		}
		let nav = UINavigationController(rootViewController: vc)

		nav.navigationBar.tintColor = Styles.Colors.tintColor
		vc.delegate = self
		rootViewController.present(nav, animated: true, completion: nil)
	}

	func cancelButtonTapped() {
		self.delegate?.addContactCoordinatorDidRequestCancel(self)
	}

	func saveButtonTapped(with contact: Contact) {
		self.delegate?.addContactCoordinatorDidRequestCancel(self)
	}
}

