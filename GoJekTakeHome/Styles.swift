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
		static let error = NSLocalizedString("Error", comment: "")
		static let okay = NSLocalizedString("Okay", comment: "")
		static let firstName = NSLocalizedString("First Name", comment: "")
		static let lastName = NSLocalizedString("Last Name", comment: "")
		static let email = NSLocalizedString("Email", comment: "")
		static let phoneNumber = NSLocalizedString("Phone Number", comment: "")
		static let mobile = NSLocalizedString("Mobile", comment: "")
		static let missingFields = NSLocalizedString("Cannot save due to missing fields: ", comment: "")
		static let loading = NSLocalizedString("Loading…", comment: "")
		static let saving = NSLocalizedString("Saving…", comment: "")

		enum Errors {
			static let cellDequeueing = NSLocalizedString("UITableView couldn't be dequeued. Obviously something went really wrong here", comment: "")
			static let viewControllerInitialization = NSLocalizedString("UIViewController could not be initialized", comment: "")
			static let dataIsNil = NSLocalizedString("Data receieved in request was nil", comment: "")
			static let clientSideError = NSLocalizedString("Whoops, looks like something failed on our end. We'll look into it 😅", comment: "")
		}

		enum ReuseIdentifiers {
			static let ContactTableViewCell = "ContactTableViewCell"
			static let EditableContactHeaderView = "EditableContactHeaderView"
			static let EditableContactAttributeCell = "EditableContactAttributeCell"
			static let ContactHeaderView = "ContactHeaderView"
			static let ContactAttributeCell = "ContactAttributeCell"
		}

		enum Actions {
			static let message = NSLocalizedString("message", comment: "")
			static let call = NSLocalizedString("call", comment: "")
			static let email = NSLocalizedString("email", comment: "")
			static let favorite = NSLocalizedString("favorite", comment: "")
		}
	}

	enum notifications {
		static let conversationListChanged = Notification.Name.init("contactListChanged")
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
		static let index = UIColor.black.withAlphaComponent(0.30)
	}
}
