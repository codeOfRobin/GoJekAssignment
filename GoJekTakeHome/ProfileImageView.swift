//
//  ProfileImageView.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 05/05/18.
//

import UIKit

// Fun fact: UIImageView has an intrinsicContentSize of (-1.0, -1.0) if you don't set an image
class ProfileImageView: UIImageView {

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.clipsToBounds = true
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = bounds.height/2
	}

	override var intrinsicContentSize: CGSize {
		return CGSize.init(width: 40.0, height: 40.0)
	}

	override func sizeThatFits(_ size: CGSize) -> CGSize {
		let edge = min(size.height, size.width)
		return CGSize(width: edge, height: edge)
	}
}
