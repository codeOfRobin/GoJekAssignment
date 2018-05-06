//
//  ContactTableViewCell.swift
//  GoJekTakeHomeTests_iOS
//
//  Created by Robin Malhotra on 05/05/18.
//

import UIKit
import AlamofireImage

//TODO: Make sure reuseIdentifiers aren't hardcoded
class ContactTableViewCell: UITableViewCell {

	let nameLabel = UILabel()
	let profileImageView = ProfileImageView(frame: .zero)
	let starView = UILabel()

	let mainStackView = UIStackView()

	// Insets are kept separately in each view for now. Given a style guide from a designer, I'd like to move them to Styles.swift
	let insets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 32)

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		self.contentView.addSubview(mainStackView)

		self.mainStackView.addArrangedSubview(profileImageView)
		self.mainStackView.addArrangedSubview(nameLabel)

		self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
		self.mainStackView.translatesAutoresizingMaskIntoConstraints = false
		self.mainStackView.alignEdges(to: self.contentView, insets: insets)

		NSLayoutConstraint.activate([
			profileImageView.widthAnchor.constraint(equalToConstant: 40),
			profileImageView.heightAnchor.constraint(equalToConstant: 40)
		])

		self.mainStackView.alignment = .center
		self.mainStackView.spacing = 10.0
		self.mainStackView.distribution = .fillProportionally
	}

	func configure(with contact: Contact.Attributes) {
		nameLabel.attributedText = NSAttributedString.init(string: "\(contact.firstName) \(contact.lastName)", attributes: Styles.Text.ContactName) 

		if let url = contact.profilePic {
			self.profileImageView.af_setImage(
				withURL: url,
				placeholderImage: #imageLiteral(resourceName: "Placeholder"),
				filter: nil,
				imageTransition: .crossDissolve(0.2)
			)
		} else {
			self.profileImageView.image = #imageLiteral(resourceName: "Placeholder")
		}

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	override func prepareForReuse() {
		super.prepareForReuse()
		profileImageView.image = nil
	}
}
