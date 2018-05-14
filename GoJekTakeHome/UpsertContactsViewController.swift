//
//  UpsertContactsViewController.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 06/05/18.
//

import UIKit

protocol UpsertContactsViewControllerDelegate: class {
	func cancelButtonTapped()
	func saveButtonTapped(with attrs: Contact.Attributes)
}

class UpsertContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	let tableView = UITableView(frame: .zero, style: .grouped)
	let leftWidth: CGFloat = 82
	var currentlyFocussedCellIndex: IndexPath?

	var firstName: String?
	var lastName: String?
	var email: String?
	var phoneNumber: String?

	weak var delegate: UpsertContactsViewControllerDelegate?

	enum InitialState {
		case add
		case update(Contact)
	}

	let initialState: InitialState

	enum State {
		case entry
		case saving
	}
	var state: State = .saving {
		didSet {
			guard oldValue != state else {
				return
			}

			switch state {
			case .entry:
				self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
				self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
			case .saving:
				let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
				activityView.startAnimating()
				self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: activityView)
				self.navigationItem.leftBarButtonItem = nil
			}
		}
	}

	var contact: Contact? {
		switch initialState {
		case .add:
			return nil
		case .update(let contact):
			return contact
		}
	}

	init(initialState: InitialState) {
		self.initialState = initialState
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.dataSource = self
		view.addSubview(tableView)

		tableView.delegate = self

		tableView.keyboardDismissMode = .onDrag

		// TODO: replace strings in all register calls
		tableView.register(EditableContactHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
		tableView.register(EditableContactAttributeCell.self, forCellReuseIdentifier: "cell")
		tableView.sectionHeaderHeight = UITableViewAutomaticDimension
		tableView.tableFooterView = UIView()

		self.state = .entry

		self.firstName = contact?.model.firstName
		self.lastName = contact?.model.lastName
		self.email = contact?.model.email
		self.phoneNumber = contact?.model.phoneNumber
        // Do any additional setup after loading the view.
    }

	@objc func saveButtonTapped() {
		//TODO: Fix this to call an actual save method
		// All fields of the new contact are mandatory in this screen (so says the mighty PDF!)
		self.state = .saving
		
		let missingFields: [String] = { [weak self] in
			var missingFields: [String] = []
			if self?.firstName == nil {
				missingFields += [Constants.Strings.firstName]
			}
			if self?.lastName == nil {
				missingFields += [Constants.Strings.lastName]
			}
			if self?.phoneNumber == nil {
				missingFields += [Constants.Strings.phoneNumber]
			}
			if self?.email == nil {
				missingFields += [Constants.Strings.email]
			}
			return missingFields
		}()

		if !missingFields.isEmpty {
			self.showErrorAlert(description: Constants.Strings.missingFields + missingFields.joined(separator: ", "))
			return
		}

		guard let firstName = firstName,
			let lastName = lastName,
			let email = email,
			let phoneNumber = phoneNumber else {
				return
		}

		let attrs = Contact.Attributes(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, profilePic: nil, favorite: false)
		self.delegate?.saveButtonTapped(with: attrs)
	}

	@objc func cancelButtonTapped() {
		delegate?.cancelButtonTapped()
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EditableContactAttributeCell else {
			//TODO: Make these kinds of errors better
			fatalError("cell not dequeued")
		}

		switch indexPath.row {
		case 0:
			cell.configure(title: "First Name", value: contact?.model.firstName ?? "", leftWidth: leftWidth)
			cell.valueTextField.addTarget(self, action: #selector(firstNameTextFieldChanged(textField:)), for: .editingChanged)
		case 1:
			cell.configure(title: "Last Name", value: contact?.model.lastName ?? "", leftWidth: leftWidth)
			cell.valueTextField.addTarget(self, action: #selector(lastNameTextFieldChanged(textField:)), for: .editingChanged)
		case 2:
			cell.configure(title: "email", value: contact?.model.email ?? "", leftWidth: leftWidth, keyboardType: .emailAddress)
			cell.valueTextField.addTarget(self, action: #selector(emailTextFieldChanged(textField:)), for: .editingChanged)
		case 3:
			cell.configure(title: "mobile", value: contact?.model.phoneNumber ?? "", leftWidth: leftWidth, keyboardType: .phonePad)
			cell.valueTextField.addTarget(self, action: #selector(phoneNumberTextFieldChanged(textField:)), for: .editingChanged)
		default:
			break
		}

		cell.valueTextField.delegate = self
		return cell
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? EditableContactHeaderView else {
			return nil
		}
		if let contact = contact, let url = contact.model.profilePic {
			header.configure(with: .url(url))
		}
		return header
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.frame = view.bounds
	}
}

extension UpsertContactsViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if let cell = textField.superview?.superview as? EditableContactAttributeCell,
			let indexPath = tableView.indexPath(for: cell) {
			currentlyFocussedCellIndex = indexPath
//			let frame = tableView.rectForRow(at: indexPath)
			tableView.contentInset.bottom = 300
		}
	}

	@objc func firstNameTextFieldChanged(textField: UITextField) {
		firstName = textField.text
	}

	@objc func lastNameTextFieldChanged(textField: UITextField) {
		lastName = textField.text
	}

	@objc func emailTextFieldChanged(textField: UITextField) {
		email = textField.text
	}

	@objc func phoneNumberTextFieldChanged(textField: UITextField) {
		phoneNumber = textField.text
	}
}
