//
//  ContactAttributeCell.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 07/05/18.
//

import UIKit

class ContactAttributeCell: UITableViewCell {
	let titleLabel = UILabel()
	let valueLabel = UILabel()
	let stackView = UIStackView()

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.addSubview(stackView)

		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(valueLabel)
		stackView.distribution = .fillEqually
		stackView.alignEdges(to: self)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(title: String, value: String) {
		titleLabel.text = title
		valueLabel.text = value
	}
}
