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

func style(from color: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight) -> [NSAttributedStringKey: Any] {
	return [
		NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight),
		NSAttributedStringKey.foregroundColor: color
	]
}

enum Constants {

	enum Strings {
	
	}

	enum Sizes {
		static let avatarSize: CGFloat = 40.0
		static let functionButtonEdge: CGFloat = 44.0
		static let largeAvatarSize: CGFloat = 120.0
	}
}

enum Styles {

	enum Text {
		static let contactName = style(from: Colors.defaultText, font: UIFont.preferredFont(forTextStyle: .body))
		static let contactHeaderName = style(from: Colors.defaultText, fontSize: UIFont.preferredFont(forTextStyle: .title3).pointSize, fontWeight: .bold)
		static let contactFunctionLabel = style(from: Colors.defaultText, font: UIFont.preferredFont(forTextStyle: .caption1))

		enum ContactAttributes {
			static let title = style(from: Colors.defaultText.withAlphaComponent(0.5), font: UIFont.preferredFont(forTextStyle: .callout))
			static let value = style(from: Colors.defaultText, font: UIFont.preferredFont(forTextStyle: .callout))
		}
	}

	enum Colors {
		static let defaultText = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.00)
		static let tintColor = UIColor(red:0.35, green:0.89, blue:0.76, alpha:1.00)
		static let background = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
	}
}
