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
	func didTapFavorite()
}

class ContactHeaderView: UITableViewHeaderFooterView {

	let profilePicImageView = UIImageView()
	let nameLabel = UILabel()

	let favoriteButton: ContactFunctionButton

	let stackView = UIStackView()

	let buttonStack = UIStackView()

	let flaggyFavoriteButton = FlaggyButton(trueImage: #imageLiteral(resourceName: "Favorite"), falseImage: #imageLiteral(resourceName: "Unfavorite"))
	let otherButtons: [ContactFunctionButton] = {
		let phoneButton = UIButton()
		phoneButton.setImage(#imageLiteral(resourceName: "Placeholder"), for: .normal)

		let messageButton = UIButton()
		messageButton.setImage(#imageLiteral(resourceName: "Placeholder"), for: .normal)

		let emailButton = UIButton()
		emailButton.setImage(#imageLiteral(resourceName: "Placeholder"), for: .normal)

		let phone = ContactFunctionButton(button: phoneButton, text: "Call")
		let message = ContactFunctionButton(button: messageButton, text: "Message")
		let email = ContactFunctionButton(button: emailButton, text: "Email")

		return [phone, message, email]
	}()

	override init(reuseIdentifier: String?) {
		self.favoriteButton = ContactFunctionButton.init(button: flaggyFavoriteButton, text: "Favorite")
		super.init(reuseIdentifier: reuseIdentifier)
		self.addSubview(stackView)

		otherButtons.forEach(buttonStack.addArrangedSubview(_:))
		buttonStack.addArrangedSubview(favoriteButton)

		stackView.addArrangedSubview(profilePicImageView)
		stackView.addArrangedSubview(nameLabel)
		stackView.addArrangedSubview(buttonStack)
		buttonStack.distribution = .fillEqually

		stackView.alignment = .center

		stackView.axis = .vertical
		stackView.alignEdges(to: self)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			profilePicImageView.widthAnchor.constraint(equalToConstant: 120),
			profilePicImageView.heightAnchor.constraint(equalToConstant: 120)
			])
		self.backgroundColor = .red
	}

	func configure(name: String, image: UIImage) {
		profilePicImageView.image = image
		nameLabel.text = name
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
