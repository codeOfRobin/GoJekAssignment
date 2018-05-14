//
//  ErrorViewController.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 14/05/18.
//

import UIKit

class ErrorViewController: UIViewController {

	let errorLabel = UILabel()

	override func viewDidLoad() {
		super.viewDidLoad()

		errorLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(errorLabel)

		self.view.backgroundColor = .white
		errorLabel.numberOfLines = 0

		NSLayoutConstraint.activate([
			errorLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30.0),
			errorLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30.0),
			errorLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
			])
		// Do any additional setup after loading the view.
	}

	func configure(text: String) {
		errorLabel.text = text
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

