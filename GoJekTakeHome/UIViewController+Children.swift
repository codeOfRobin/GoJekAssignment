//
//  UIViewController+Children.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 14/05/18.
//

import UIKit

extension UIViewController {
	public func add(_ child: UIViewController) {
		addChildViewController(child)
		view.addSubview(child.view)
		child.didMove(toParentViewController: self)
	}

	public func remove() {
		guard parent != nil else {
			return
		}

		willMove(toParentViewController: nil)
		removeFromParentViewController()
		view.removeFromSuperview()
	}
}

