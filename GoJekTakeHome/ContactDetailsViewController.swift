//
//  ContactDetailsViewController.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 06/05/18.
//

import UIKit

protocol ContactHeaderDelegate: class {
	func didTapMessages()
	func didTapPhone()
	func didTapEmail()
	func didTapFavorite()
}

class ContactHeaderView: UIView {

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

	override init(frame: CGRect) {
		self.favoriteButton = ContactFunctionButton.init(button: flaggyFavoriteButton, text: "Favorite")
		super.init(frame: frame)
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
	}

	func configure(name: String, image: UIImage) {
		profilePicImageView.image = image
		nameLabel.text = name
	}



	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}


class ContactFunctionButton: UIView {
	let label = UILabel()
	let button: UIButton
	let stackView = UIStackView()

	init(button: UIButton, text: String) {
		self.button = button
		super.init(frame: .zero)

		label.text = text
		stackView.addArrangedSubview(button)
		stackView.addArrangedSubview(label)
		stackView.axis = .vertical
		stackView.alignment = .center
		self.addSubview(stackView)

		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.alignEdges(to: self)

	}

	override var intrinsicContentSize: CGSize {
		return stackView.intrinsicContentSize
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


protocol FlaggyButtonDelegate: class {
	func stateDidChange(to state: Bool)
}

class FlaggyButton: UIButton {

	weak var delegate: FlaggyButtonDelegate?

	var flag: Bool = true {
		didSet {
			self.setImage(flag ? trueImage : falseImage, for: UIControlState.normal)
		}
	}

	let trueImage: UIImage
	let falseImage: UIImage

	init(trueImage: UIImage, falseImage: UIImage)  {
		self.trueImage = trueImage
		self.falseImage = falseImage
		super.init(frame: .zero)
		self.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
		self.setImage(trueImage, for: .normal)
	}

	@objc func didTapButton() {
		self.flag = !flag
		self.delegate?.stateDidChange(to: self.flag)
	}

	override var intrinsicContentSize: CGSize {
		return CGSize(width: 44.0, height: 44.0)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


class ContactDetailsViewController: UIViewController {

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	let contactHeaderView = ContactHeaderView(frame: .zero)



    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .white

		self.view.addSubview(contactHeaderView)
		contactHeaderView.translatesAutoresizingMaskIntoConstraints = false
		contactHeaderView.alignEdges(to: self.view, insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 300, right: 0))
		contactHeaderView.configure(name: "asdkfnkadsjfnkjdsnf", image: #imageLiteral(resourceName: "Placeholder"))

        // Do any additional setup after loading the view.
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
