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
	let gradientColors = [UIColor.white, UIColor(red:0.87, green:0.96, blue:0.94, alpha:1.00)]

	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)

		self.contentView.addSubview(profileImageView)
		profileImageView.translatesAutoresizingMaskIntoConstraints = false
		profileImageView.image = #imageLiteral(resourceName: "Placeholder")
		profileImageView.clipsToBounds = true
		NSLayoutConstraint.activate([
			profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 19),
			profileImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30),
			profileImageView.widthAnchor.constraint(equalToConstant: Constants.Sizes.largeAvatarSize),
			profileImageView.heightAnchor.constraint(equalToConstant: Constants.Sizes.largeAvatarSize),
			profileImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
			])

		gradientLayer.colors = gradientColors.map { $0.cgColor }
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
		profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
	}
}

class EditableContactAttributeCell: UITableViewCell {
	let titleLabel = UILabel()
	let valueTextField = UITextField()
	let stackView = UIStackView()

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.addSubview(stackView)

		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(valueTextField)
		stackView.spacing = 32

		stackView.alignEdges(to: self, insets: UIEdgeInsets(top: 18, left: 25, bottom: 18, right: 25))
		self.contentView.backgroundColor = Styles.Colors.background
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(title: String, value: String, leftWidth: CGFloat, keyboardType: UIKeyboardType =  UIKeyboardType.default, autoCapitalizationType: UITextAutocapitalizationType = .none) {
		NSLayoutConstraint.activate([
			self.titleLabel.widthAnchor.constraint(equalToConstant: leftWidth)
			])
		titleLabel.attributedText = NSAttributedString(string: title, attributes: Styles.Text.ContactAttributes.title)
		valueTextField.attributedText = NSAttributedString(string: value, attributes: Styles.Text.ContactAttributes.value)
		valueTextField.keyboardType = keyboardType
		titleLabel.textAlignment = .right

		valueTextField.autocapitalizationType = autoCapitalizationType
		valueTextField.autocorrectionType = .no
		valueTextField.spellCheckingType = .no
	}
}
