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
