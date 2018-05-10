//
//  ModifyContactsViewController.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 06/05/18.
//

import UIKit

class ModifyContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	let contact: Contact.Attributes?
	let tableView = UITableView(frame: .zero, style: .grouped)
	let leftWidth: CGFloat = 82

	init() {
		self.contact = nil
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
        // Do any additional setup after loading the view.
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
			cell.configure(title: "First Name", value: "Polly", leftWidth: leftWidth)
		case 1:
			cell.configure(title: "Last Name", value: "Richardson", leftWidth: leftWidth)
		case 2:
			cell.configure(title: "email", value: "askdfnkj", leftWidth: leftWidth)
		case 3:
			cell.configure(title: "mobile", value: "sadfkjnsdfkjn", leftWidth: leftWidth)
		default:
			break
		}
		return cell
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? EditableContactHeaderView else {
			return nil
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
