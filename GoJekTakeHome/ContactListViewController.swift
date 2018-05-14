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

		// TODO: Replace with APIClient
		services.apiClient.getContacts { [weak self] (result) in
			switch result {
			case .success(let contacts):
				self?.services.contacts.elements = contacts
				self?.tableView.reloadData()
			case .failure(let error):
				break
			}
		}


		self.tableView.sectionIndexColor = Styles.Colors.index
		self.title = "Contacts"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addContactButtonTapped))
        // Do any additional setup after loading the view.
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
