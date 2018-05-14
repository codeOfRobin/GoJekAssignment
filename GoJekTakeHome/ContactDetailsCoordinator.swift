//
//  ContactDetailsCoordinator.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 12/05/18.
//

import UIKit

protocol ContactDetailsCoordinatorDelegate: class {
	func userTappedBackButton(on coordinator: ContactDetailsCoordinator)
}

class ContactDetailsCoordinator: Coordinator, ContactDetailsViewControllerDelegate {

	let rootViewController: UINavigationController
	let contact: Contact
	let services: Services

	var viewController: ContactDetailsViewController?
	var updateContactCoordinator: UpdateContactCoordinator?

	weak var delegate: ContactDetailsCoordinatorDelegate?

	var favoriteRequestInProgress: URLSessionDataTask?

	init(contact: Contact, services: Services, rootViewController: UINavigationController) {
		self.contact = contact
		self.rootViewController = rootViewController
		self.services = services
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

	func backButtonTapped(_ vc: ContactDetailsViewController) {
		delegate?.userTappedBackButton(on: self)
	}

	func changeFavoriteState(_ vc: ContactDetailsViewController, contact: Contact, state: Bool) {
		// in the real world, I'd throw Rx at this problem
		if let currentlyRunningRequest = favoriteRequestInProgress {
			currentlyRunningRequest.cancel()
			favoriteRequestInProgress = nil
		}

		let services = self.services
		let request = services.apiClient.setFavoriteState(state, of: contact) { (result) in
			switch result {
			case .success(let contact):
				guard let index = services.contacts.index(of: contact) else {
					return
				}
				services.contacts.elements[index] = contact
			case .failure(let error):
				// cancellations are errors in URLSession 🤬
				print(error)
			}
		}

		favoriteRequestInProgress = request
	}
}
