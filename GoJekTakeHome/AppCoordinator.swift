//
//  AppCoordinator.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 05/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController {

}

protocol Coordinator {
	func start()
}

// http://khanlou.com/2015/10/coordinators-redux/
class AppCoordinator: Coordinator {

	let rootViewController: RootViewController

	init(root: RootViewController) {
		self.rootViewController = root
	}

	func start() {
		let emptyViewController = ContactListViewController()
		self.rootViewController.viewControllers = [emptyViewController]
	}
	
}


class AllContactListCoordinator: Coordinator {

	func start() {
	}


}
