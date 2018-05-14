//
//  LoadingViewController.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 14/05/18.
//

import UIKit

class LoadingViewController: UIViewController {

	lazy var activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)

	override func viewDidLoad() {
		super.viewDidLoad()

		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(activityIndicator)

		self.view.backgroundColor = .white

		NSLayoutConstraint.activate([
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
			])
		// Do any additional setup after loading the view.
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.activityIndicator.stopAnimating()
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
			self?.activityIndicator.startAnimating()
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

