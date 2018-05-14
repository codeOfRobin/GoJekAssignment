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
	var contact: Contact {
		didSet {
			self.viewController?.state = .loadedFullDetails(contact)
		}
	}
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
		viewController = ContactDetailsViewController(contact: contact, services: services)
		guard let vc = viewController else {
			fatalError(Constants.Strings.Errors.viewControllerInitialization)
		}
		vc.delegate = self
		rootViewController.pushViewController(vc, animated: true)
	}

	func editButtonTapped(_ vc: ContactDetailsViewController, contact: Contact) {
		updateContactCoordinator = UpdateContactCoordinator(rootViewController: self.rootViewController, contact: contact, services: services)
		guard let coordinator = updateContactCoordinator else {
			fatalError(Constants.Strings.Errors.viewControllerInitialization)
		}
		coordinator.start()
		coordinator.delegate = self
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

extension ContactDetailsCoordinator: UpdateContactCoordinatorDelegate {
	func updateContactCoordinator(_ updateContactCoordinator: UpdateContactCoordinator, didUpdateContact contact: Contact) {
		updateContactCoordinator.viewController?.dismiss(animated: true, completion: nil)
		self.contact = contact
		//TODO: I don't think calling this here would be a good idea
		self.viewController?.state = .loadedFullDetails(contact)
		self.viewController?.tableView.reloadData()
		guard let index = services.contacts.elements.index(where: { (contactInfo) -> Bool in
			contactInfo.id == contact.id
		}) else {
			return
		}
		services.contacts.elements[index] = contact
	}

	func updateContactCoordinatorDidRequestCancel(_ updateContactCoordinator: UpdateContactCoordinator) {
		updateContactCoordinator.viewController?.dismiss(animated: true, completion: nil)
		self.updateContactCoordinator = nil
	}
}
