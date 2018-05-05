//
//  UIView+AlignEdges.swift
//  GoJekTakeHomeTests_iOS
//
//  Created by Robin Malhotra on 05/05/18.
//

import UIKit

extension UIView {
	func alignEdges(to otherView: UIView, insets: UIEdgeInsets = .zero) {
		// calling this is more efficient than setting `isActive = true` for individual constraints
		NSLayoutConstraint.activate([
			self.topAnchor.constraint(equalTo: otherView.topAnchor, constant: insets.top),
			self.bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: -insets.bottom),
			self.leftAnchor.constraint(equalTo: otherView.leftAnchor, constant: insets.left),
			self.rightAnchor.constraint(equalTo: otherView.rightAnchor, constant: -insets.right)
		])
	}
}
