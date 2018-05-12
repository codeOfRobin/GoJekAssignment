//
//  Avatar.swift
//  GoJekTakeHome_iOS
//
//  Created by Robin Malhotra on 12/05/18.
//

import UIKit
import AlamofireImage

enum Avatar {
	case image(UIImage)
	case url(URL)
}

extension UIImageView {
	func setAvatar(_ avatar: Avatar) {
		switch avatar {
		case .image(let image):
			self.image = image
		case .url(let url):
			self.af_setImage(withURL: url)
		}
	}
}
