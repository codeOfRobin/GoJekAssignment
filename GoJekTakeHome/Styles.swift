//
//  Styles.swift
//  GoJekTakeHomeTests_iOS
//
//  Created by Robin Malhotra on 06/05/18.
//

import UIKit

func style(from color: UIColor, font: UIFont) -> [NSAttributedStringKey: Any] {
	return [
		NSAttributedStringKey.font: font,
		NSAttributedStringKey.foregroundColor: color
	]
}

enum Constants {

	enum Strings {
	
	}

	enum Sizes {
		static let avatarSize: CGFloat = 40.0
	}
}

enum Styles {

	enum Text {
		static let ContactName = style(from: Colors.defaultText, font: UIFont.preferredFont(forTextStyle: .body))
	}

	enum Colors {
		static let defaultText = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.00)
		static let tintColor = UIColor(red:0.35, green:0.89, blue:0.76, alpha:1.00)
	}
}
