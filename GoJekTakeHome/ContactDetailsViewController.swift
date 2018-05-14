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

class ContactDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ContactHeaderDelegate {

	var contact: Contact {
		didSet {
			self.tableView.reloadData()
		}
	}

	weak var delegate: ContactDetailsViewControllerDelegate?

	let contactHeaderView = ContactHeaderView(frame: .zero)
	let tableView = UITableView(frame: .zero, style: .grouped)
	let leftWidth: CGFloat = 70

	enum State {
		case loading
		case loadedFullDetails(Contact)
	}

	var state: State = .loading

	init(contact: Contact) {
		self.contact = contact
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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

		self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))

		self.tableView.backgroundColor = Styles.Colors.background

		NotificationCenter.default.addObserver(forName: Constants.notifications.conversationListChanged, object: nil, queue: .main) { (_) in

		}
        // Do any additional setup after loading the view.
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
		header.configure(name: contact.model.name, avatar: avatar)
		header.delegate = self
		return header
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ContactAttributeCell else {
			fatalError()
		}

		switch indexPath.row {
		case 0:
			//TODO: Maybe don't display these cells?
			cell.configure(title: Constants.Strings.mobile, value: contact.model.phoneNumber ?? "", leftWidth: leftWidth)
		case 1:
			//TODO: Maybe don't display these cells if null?
			cell.configure(title: Constants.Strings.email, value: contact.model.email ?? "", leftWidth: leftWidth)
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
