//
//  ContactDetailsViewController.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 06/05/18.
//

import UIKit

class ContactDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	let contact: Contact.Attributes

	init(contact: Contact.Attributes) {
		self.contact = contact
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	let contactHeaderView = ContactHeaderView(frame: .zero)

	let tableView = UITableView.init(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .white

		contactHeaderView.translatesAutoresizingMaskIntoConstraints = false
		contactHeaderView.configure(name: "asdkfnkadsjfnkjdsnf", image: #imageLiteral(resourceName: "Placeholder"))

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
        // Do any additional setup after loading the view.
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
		header.configure(name: "sdakfnksdjnfkjn", image: #imageLiteral(resourceName: "Placeholder"))
		return header
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ContactAttributeCell else {
			fatalError()
		}

		cell.configure(title: "asdkjfnksdjf", value: "sadfkjnsadfkjsadf")
		return cell
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
