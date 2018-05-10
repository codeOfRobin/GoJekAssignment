//
//  AddUpdateCoordinator.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 10/05/18.
//

import UIKit

protocol AddUpdateContactCoordinatorDelegate: class {
	func addUpdateContactCoordinatorDidRequestCancel(_ addUpdateContactCoordinator: AddUpdateContactCoordinator)
	func addUpdateContactCoordinator(_ addUpdateContactCoordinator: AddUpdateContactCoordinator, didAddContact contactPayload: Contact.Attributes)
	func addUpdateContactCoordinator(_ addUpdateContactCoordinator: AddUpdateContactCoordinator, didUpdateContact contactPayload: Contact)
}

class AddUpdateContactCoordinator: Coordinator, AddUpdateContactsViewControllerDelegate {

	let rootViewController: UINavigationController
	weak var delegate: AddUpdateContactCoordinatorDelegate?

	init(rootViewController: UINavigationController) {
		self.rootViewController = rootViewController
	}

	func start() {
		let vc = AddUpdateContactsViewController(initialState: .add)
		let nav = UINavigationController(rootViewController: vc)

		nav.navigationBar.tintColor = Styles.Colors.tintColor
		vc.delegate = self
		rootViewController.present(nav, animated: true, completion: nil)
	}

	func cancelButtonTapped() {
		self.delegate?.addUpdateContactCoordinatorDidRequestCancel(self)
	}

	func saveButtonTapped(with contact: Contact) {
		self.delegate?.addUpdateContactCoordinatorDidRequestCancel(self)
	}
}

