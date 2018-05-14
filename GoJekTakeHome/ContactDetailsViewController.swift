//
//  ContactDetailsViewController.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 06/05/18.
//

import UIKit

protocol ContactDetailsViewControllerDelegate: class {
	// TODO: make sure delegate type signatures pass in the VC
	func editButtonTapped(_ vc: ContactDetailsViewController, contact: Contact)
	func backButtonTapped(_ vc: ContactDetailsViewController)
	func changeFavoriteState(_ vc: ContactDetailsViewController, contact: Contact, state: Bool)
}

extension ContactDetailsViewController.State: Equatable {}
internal func == (lhs: ContactDetailsViewController.State, rhs: ContactDetailsViewController.State) -> Bool {
	switch (lhs, rhs) {
	case (.loading, .loading):
		return true
	case (.error(let error1), .error(let error2)):
		// We could make this more efficient by doing a deeper comparison, but I'm gonna be lazy here 😛
		return error1.0.localizedDescription == error2.0.localizedDescription
	case (.loadedFullDetails, .loadedFullDetails):
		return true
	default: return false
	}
}

class ContactDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ContactHeaderDelegate {

	weak var delegate: ContactDetailsViewControllerDelegate?

	let contactHeaderView = ContactHeaderView(frame: .zero)
	let tableView = UITableView(frame: .zero, style: .grouped)
	let leftWidth: CGFloat = 70
	let services: Services

	enum State {
		case loading(Contact)
		case loadedFullDetails(Contact)
		case error(Error, Contact)
	}

	init(contact: Contact, services: Services) {
		self.services = services
		self.state = .loading(contact)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	var state: State {
		didSet {
			guard oldValue != state else {
				return
			}

			switch state {
			case .loadedFullDetails:
				self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
			tableView.reloadData()
			default:
				break
			}
		}
	}

	var contact: Contact {
		switch state {
		case .error(_, let contact):
			return contact
		case .loading(let contact):
			return contact
		case .loadedFullDetails(let contact):
			return contact
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .white

		tableView.translatesAutoresizingMaskIntoConstraints = false


		self.view.addSubview(tableView)
		tableView.dataSource = self
		tableView.delegate = self

		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.sectionHeaderHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 44.0
		//TODO: remove string identifiers
		tableView.register(ContactHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
		tableView.register(ContactAttributeCell.self, forCellReuseIdentifier: "cell")
		tableView.tableFooterView = UIView()

		self.tableView.backgroundColor = Styles.Colors.background
        // Do any additional setup after loading the view.
		loadDetails()
    }

	func loadDetails() {
		if case .loading(let partialContact) = state {
			self.services.apiClient.getContact(with: partialContact.id) { [weak self] (result) in
				switch result {
				case .success(let contact):
					self?.state = .loadedFullDetails(contact)
				case .failure(let error):
					self?.state = .error(error, partialContact)
				}
			}
		}
	}

	@objc func editButtonTapped() {
		delegate?.editButtonTapped(self, contact: contact)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.frame = view.bounds
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? ContactHeaderView else {
			fatalError()
		}
		let avatar: Avatar = {
			if let url = contact.model.profilePic {
				return .url(url)
			} else {
				return .image(#imageLiteral(resourceName: "Placeholder"))
			}
		}()
		header.configure(name: contact.model.name, avatar: avatar, favoriteState: contact.model.favorite)
		header.delegate = self
		return header
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ContactAttributeCell else {
			fatalError()
		}

		let valueToDisplay: (String?) -> String = { string in
			if case .loading = self.state {
				return Constants.Strings.loading
			} else {
				return string ?? ""
			}
		}

		switch indexPath.row {
		case 0:
			//TODO: Maybe don't display these cells?
			cell.configure(title: Constants.Strings.mobile, value: valueToDisplay(contact.model.phoneNumber), leftWidth: leftWidth)
		case 1:
			//TODO: Maybe don't display these cells if null?
			cell.configure(title: Constants.Strings.email, value: valueToDisplay(contact.model.email), leftWidth: leftWidth)
		default:
			break
		}
		return cell
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if self.isMovingFromParentViewController {
			delegate?.backButtonTapped(self)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func didTapFavorite(with state: Bool) {
		delegate?.changeFavoriteState(self, contact: contact, state: state)
	}

}
