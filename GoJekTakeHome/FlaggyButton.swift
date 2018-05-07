//
//  FlaggyButton.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 07/05/18.
//

import UIKit

protocol FlaggyButtonDelegate: class {
	func stateDidChange(to state: Bool)
}

class FlaggyButton: UIButton {

	weak var delegate: FlaggyButtonDelegate?

	var flag: Bool = true {
		didSet {
			self.setImage(flag ? trueImage : falseImage, for: UIControlState.normal)
		}
	}

	let trueImage: UIImage
	let falseImage: UIImage

	init(trueImage: UIImage, falseImage: UIImage)  {
		self.trueImage = trueImage
		self.falseImage = falseImage
		super.init(frame: .zero)
		self.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
		self.setImage(trueImage, for: .normal)
	}

	@objc func didTapButton() {
		self.flag = !flag
		self.delegate?.stateDidChange(to: self.flag)
	}

	override var intrinsicContentSize: CGSize {
		return CGSize(width: Constants.Sizes.avatarSize, height: Constants.Sizes.avatarSize)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
