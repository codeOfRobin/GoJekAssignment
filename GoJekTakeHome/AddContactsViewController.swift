//
//  AddContactsViewController.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 10/05/18.
//

import UIKit

class EditableContactHeaderView: UITableViewHeaderFooterView {
	let gradientLayer = CAGradientLayer()

	let profileImageView = UIImageView()

	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)

		self.contentView.addSubview(profileImageView)
		profileImageView.translatesAutoresizingMaskIntoConstraints = false
		profileImageView.image = #imageLiteral(resourceName: "Placeholder")
		NSLayoutConstraint.activate([
			profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 19),
			profileImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30),
			profileImageView.widthAnchor.constraint(equalToConstant: Constants.Sizes.largeAvatarSize),
			profileImageView.heightAnchor.constraint(equalToConstant: Constants.Sizes.largeAvatarSize),
			profileImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
			])

		//TODO: Move this color into its own variable
		gradientLayer.colors = [UIColor.white.cgColor, UIColor(red:0.87, green:0.96, blue:0.94, alpha:1.00).cgColor]
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
		self.layer.insertSublayer(gradientLayer, at: 0)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		gradientLayer.frame = layer.bounds
	}
}

class EditableContactAttributeCell: UITableViewCell {
	let titleLabel = UITextField()
	let valueLabel = UITextField()
	let stackView = UIStackView()

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.addSubview(stackView)

		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(valueLabel)
		stackView.spacing = 32

		stackView.alignEdges(to: self, insets: UIEdgeInsets(top: 18, left: 25, bottom: 18, right: 25))
		self.contentView.backgroundColor = Styles.Colors.background
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(title: String, value: String, leftWidth: CGFloat) {
		NSLayoutConstraint.activate([
			self.titleLabel.widthAnchor.constraint(equalToConstant: leftWidth)
			])
		titleLabel.attributedText = NSAttributedString(string: title, attributes: Styles.Text.ContactAttributes.title)
		valueLabel.attributedText = NSAttributedString(string: value, attributes: Styles.Text.ContactAttributes.value)
		titleLabel.textAlignment = .right
	}
}

class AddContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	weak var delegate: AddContactDelegate?

	let tableView = UITableView()
	let leftWidth: CGFloat = 82

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.addSubview(tableView)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.frame = view.bounds

		tableView.register(EditableContactAttributeCell.self, forCellReuseIdentifier: "cell")
		tableView.register(EditableContactHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// FirstName, LastName, mobile, email
		return 4
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EditableContactAttributeCell else {
			//TODO: Fix these errors to something more descriptive
			fatalError("can't dequeue cell")
		}

		switch indexPath.row {
		case 0:
			cell.configure(title: "First Name", value: "", leftWidth: leftWidth)
		case 1:
			cell.configure(title: "Last Name", value: "", leftWidth: leftWidth)
		case 2:
			cell.configure(title: "Mobile", value: "", leftWidth: leftWidth)
		case 3:
			cell.configure(title: "Email", value: "", leftWidth: leftWidth)
		default:
			break
		}
		return cell
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? EditableContactHeaderView else {
			//TODO: Fix these errors to something more descriptive
			fatalError("can't dequeue header")
		}

		return header
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
