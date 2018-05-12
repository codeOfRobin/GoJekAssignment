//
//  EditableContactHeaderView.swift
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

	func configure(with avatar: Avatar) {
		self.profileImageView.setAvatar(avatar)
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
