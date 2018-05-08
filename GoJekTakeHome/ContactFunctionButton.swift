//
//  ContactFunctionButton.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 07/05/18.
//

import UIKit

class ContactFunctionButton: UIView {
	let label = UILabel()
	let button: UIButton
	let stackView = UIStackView()

	init(button: UIButton, text: String) {
		self.button = button
		super.init(frame: .zero)

		label.attributedText = NSAttributedString(string: text, attributes: Styles.Text.contactFunctionLabel)
		stackView.addArrangedSubview(button)
		stackView.addArrangedSubview(label)
		stackView.axis = .vertical
		stackView.alignment = .center
		button.contentEdgeInsets = .zero

		stackView.spacing = 5.0
		self.addSubview(stackView)


		NSLayoutConstraint.activate([
			button.widthAnchor.constraint(equalToConstant: Constants.Sizes.functionButtonEdge),
			button.heightAnchor.constraint(equalToConstant: Constants.Sizes.functionButtonEdge)
			])

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

