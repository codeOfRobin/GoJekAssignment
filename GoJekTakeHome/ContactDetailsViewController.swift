//
//  ContactDetailsViewController.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 06/05/18.
//

import UIKit

protocol ContactHeaderDelegate: class {
	func didTapMessages()
	func didTapPhone()
	func didTapEmail()
	func didTapFavorite()
}

class ContactHeaderView: UIView {

	let profilePicImageView = UIImageView()
	let nameLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubview(profilePicImageView)
		self.addSubview(nameLabel)
	}



	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

class ContactFunctionButtons: UIView {

	let stack = UIStackView()

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}


class ContactFunctionButton: UIView {
	let label = UILabel()
	let button: UIButton

	init(button: UIButton) {
		self.button = button
		super.init(frame: .zero)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


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
		return CGSize.init(width: 44.0, height: 44.0)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


class ContactDetailsViewController: UIViewController {

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	let flaggyButton = FlaggyButton(trueImage: #imageLiteral(resourceName: "Favorite"), falseImage: #imageLiteral(resourceName: "Unfavorite"))

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.addSubview(flaggyButton)

		self.view.backgroundColor = .white

		self.flaggyButton.tintColor = .red

        // Do any additional setup after loading the view.
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		flaggyButton.frame = CGRect.init(x: 100, y: 100, width: 44, height: 44)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
