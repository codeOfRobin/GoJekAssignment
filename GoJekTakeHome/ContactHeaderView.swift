//
//  ContactHeaderView.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 07/05/18.
//

import UIKit

protocol ContactHeaderDelegate: class {
	func didTapMessages()
	func didTapPhone()
	func didTapEmail()
	func didTapFavorite(with state: Bool)
}

extension ContactHeaderDelegate {
	func didTapMessages() {

	}

	func didTapPhone() {

	}

	func didTapEmail() {

	}
}

class ContactHeaderView: UITableViewHeaderFooterView {

	let profilePicImageView = UIImageView()
	let nameLabel = UILabel()

	let favoriteButton: ContactFunctionButton

	let stackView = UIStackView()

	let buttonStack = UIStackView()

	let gradientLayer = CAGradientLayer()

	let flaggyFavoriteButton = FlaggyButton(trueImage: #imageLiteral(resourceName: "Favorite"), falseImage: #imageLiteral(resourceName: "Unfavorite"))
	let otherButtons: [ContactFunctionButton] = {
		let phoneButton = UIButton()
		phoneButton.setImage(#imageLiteral(resourceName: "call"), for: .normal)

		let messageButton = UIButton()
		messageButton.setImage(#imageLiteral(resourceName: "Sms"), for: .normal)

		let emailButton = UIButton()
		emailButton.setImage(#imageLiteral(resourceName: "Email"), for: .normal)

		let phone = ContactFunctionButton(button: phoneButton, text: Constants.Strings.Actions.call)
		let message = ContactFunctionButton(button: messageButton, text: Constants.Strings.Actions.message)
		let email = ContactFunctionButton(button: emailButton, text: Constants.Strings.Actions.email)

		return [message, phone, email]
	}()

	let insets = UIEdgeInsets(top: 19, left: 44, bottom: 12, right: 44)

	// this has custom colors because of where the gradient begins
	let gradientColors = [UIColor(red:0.99, green:0.99, blue:0.99, alpha:1.00), UIColor(red:0.87, green:0.96, blue:0.94, alpha:1.00)]

	weak var delegate: ContactHeaderDelegate?

	override init(reuseIdentifier: String?) {
		self.favoriteButton = ContactFunctionButton.init(button: flaggyFavoriteButton, text: Constants.Strings.Actions.favorite)
		super.init(reuseIdentifier: reuseIdentifier)
		self.contentView.addSubview(stackView)

		otherButtons.forEach(buttonStack.addArrangedSubview(_:))
		buttonStack.addArrangedSubview(favoriteButton)
		buttonStack.distribution = .equalSpacing

		stackView.addArrangedSubview(profilePicImageView)
		stackView.addArrangedSubview(nameLabel)
		stackView.addArrangedSubview(buttonStack)
		buttonStack.distribution = .equalSpacing

		profilePicImageView.clipsToBounds = true

		NSLayoutConstraint.activate([
			buttonStack.leftAnchor.constraint(equalTo: stackView.leftAnchor),
			buttonStack.rightAnchor.constraint(equalTo: stackView.rightAnchor)
		])


		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.alignEdges(to: self.contentView, insets: insets)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			profilePicImageView.widthAnchor.constraint(equalToConstant: Constants.Sizes.largeAvatarSize),
			profilePicImageView.heightAnchor.constraint(equalToConstant: Constants.Sizes.largeAvatarSize)
		])

		self.stackView.setCustomSpacing(8.0, after: profilePicImageView)
		self.stackView.setCustomSpacing(24.0, after: nameLabel)

		self.gradientLayer.colors = gradientColors.map { $0.cgColor }
		self.gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
		self.gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1.0)
		self.contentView.layer.insertSublayer(gradientLayer, at: 0)

		//really only need to implement one of these
		self.flaggyFavoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
	}

	@objc func favoriteButtonTapped() {
		delegate?.didTapFavorite(with: flaggyFavoriteButton.flag)
	}

	override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		gradientLayer.frame = layer.bounds
		profilePicImageView.layer.cornerRadius = profilePicImageView.bounds.height/2
	}

	func configure(name: String, avatar: Avatar, favoriteState: Bool) {
		flaggyFavoriteButton.flag  = favoriteState
		profilePicImageView.setAvatar(avatar)
		nameLabel.attributedText = NSAttributedString.init(string: name, attributes: Styles.Text.contactHeaderName)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
