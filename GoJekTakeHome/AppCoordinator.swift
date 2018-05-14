//
//  AppCoordinator.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 05/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

public class Services {

	var contacts = SortedArray<Contact>() {
		didSet {
			NotificationCenter.default.post(name: Constants.notifications.conversationListChanged, object: nil)
		}
	}
	let apiClient: APIClient

	init(session: URLSession = .shared) {
		self.apiClient = APIClient.init(session: session)
	}

}


protocol Coordinator {
	func start()
}

// http://khanlou.com/2015/10/coordinators-redux/
class AppCoordinator: Coordinator {

	let allContactListCoordinator: AllContactListCoordinator

	let rootViewController: UINavigationController = {
		let nav = UINavigationController()
		nav.navigationBar.prefersLargeTitles = false
		return nav
	}()

	let window: UIWindow
	let services: Services

	init(window: UIWindow) {
		self.window = window

		self.window.rootViewController = rootViewController
		self.window.makeKeyAndVisible()

		self.services = Services()

		self.allContactListCoordinator = AllContactListCoordinator(rootViewController: rootViewController, services: services)

		rootViewController.navigationBar.tintColor = Styles.Colors.tintColor
	}

	func start() {
		allContactListCoordinator.start()
	}

}
