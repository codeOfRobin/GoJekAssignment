//
//  ContactListViewController.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 05/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

protocol ContactListDelegate: class {
	func didAskForNewContact(vc: ContactListViewController)
	func didAskForContactDetails(vc: ContactListViewController, contact: Contact)
}


extension ContactListViewController.State: Equatable {}
internal func == (lhs: ContactListViewController.State, rhs: ContactListViewController.State) -> Bool {
	switch (lhs, rhs) {
	case (.loading, .loading):
		return true
	case (.error(let error1), .error(let error2)):
		// We could make this more efficient by doing a deeper comparison, but I'm gonna be lazy here 😛
		return error1.localizedDescription == error2.localizedDescription
	case (.loaded, .loaded):
		return true
	default: return false
	}
}

class ContactListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	let tableView = UITableView()
	let collation = UILocalizedIndexedCollation.current()
	let services: Services

	weak var delegate: ContactListDelegate?

	init(services: Services) {
		self.services = services
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// Don't need actual contacts
	var sections: [[Contact]] = []
	var contacts: [Contact] = [] {
		didSet {
			sections = Array.init(repeating: [], count: collation.sectionTitles.count)

			let sortedObjects = contacts
			for object in sortedObjects {
				let sectionNumber = collation.section(for: object.model.name, collationStringSelector: #selector(getter: NSString.lowercased))
				sections[sectionNumber].append(object)
			}
			self.tableView.reloadData()
		}
	}

	lazy var loadingVC = LoadingViewController(nibName: nil, bundle: nil)
	lazy var errorVC = ErrorViewController(nibName: nil, bundle: nil)

	enum State {
		case loading(LoadingViewController)
		case error(Error)
		case loaded
	}

	var state: State = .loaded {
		didSet {
			guard oldValue != state else {
				return
			}

			switch oldValue {
			case .loading:
				loadingVC.remove()
			case .error:
				errorVC.remove()
			default:
				break
			}

			switch state {
			case .loading:
				self.add(loadingVC)
			case .error(let error):
				self.errorVC.configure(text: error.localizedDescription)
				self.add(errorVC)
			default:
				return
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		self.view.backgroundColor = .white

		self.view.addSubview(tableView)
		tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "cell")

		tableView.dataSource = self
		tableView.delegate = self

		NotificationCenter.default.addObserver(forName: Constants.notifications.conversationListChanged, object: nil, queue: .main) { [weak self] (_) in
			if let contacts = self?.services.contacts.elements {
				self?.contacts = contacts
				self?.tableView.reloadData()
			}
		}

		self.tableView.sectionIndexColor = Styles.Colors.index
		self.title = "Contacts"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addContactButtonTapped))
		self.loadItems()
        // Do any additional setup after loading the view.
	}

	func loadItems() {

		self.state = .loading(loadingVC)
		services.apiClient.getContacts { [weak self] (result) in
			switch result {
			case .success(let contacts):
				self?.services.contacts.elements = contacts
				self?.tableView.reloadData()
				self?.state = .loaded
			case .failure(let error):
				self?.state = .error(error)
			}
		}
	}

	@objc func addContactButtonTapped() {
		delegate?.didAskForNewContact(vc: self)
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let contact = sections[indexPath.section][indexPath.row]
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ContactTableViewCell else {
			fatalError("Cannot dequeue cell")
		}

		cell.configure(with: contact.model)
		return cell
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.frame = view.bounds
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return collation.sectionTitles[section]
	}

	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return collation.sectionIndexTitles
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let contact = sections[indexPath.section][indexPath.row]
		delegate?.didAskForContactDetails(vc: self, contact: contact)
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return collation.section(forSectionIndexTitle: index)
	}

}
