//
//  UIViewController+ErrorAlert.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 13/05/18.
//

import UIKit

extension UIViewController {
	func showErrorAlert(description: String) {
		let alertControler = UIAlertController.init(title: Constants.Strings.error, message: description, preferredStyle: .alert)
		alertControler.addAction(UIAlertAction.init(title: Constants.Strings.okay, style: .default, handler: { (action) in
			alertControler.dismiss(animated: true, completion: nil)
		}))
		self.present(alertControler, animated: true, completion: nil)
	}
}
