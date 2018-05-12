//
//  AppCoordinator.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 05/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

public struct Services {

	public let dataService: DataService

	public init() {
		self.dataService = DataService()
	}
}

public class DataService {

	var contacts = SortedArray<Contact>()
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

	init(window: UIWindow) {
		self.window = window

		self.window.rootViewController = rootViewController
		self.window.makeKeyAndVisible()

		self.allContactListCoordinator = AllContactListCoordinator(rootViewController: rootViewController)

		rootViewController.navigationBar.tintColor = Styles.Colors.tintColor
	}

	func start() {
		allContactListCoordinator.start()
	}

}
