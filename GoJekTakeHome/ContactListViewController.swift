//
//  ContactListViewController.swift
//  GoJekTakeHome
//
//  Created by Robin Malhotra on 05/05/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController, UITableViewDataSource {

	let tableView = UITableView()

	let imageDownloader = ProfilePictureDownloader()

	let session: URLSession
	let requestBuilder = APIRequestBuilder()

	init(session: URLSession = .shared) {
		self.session = session
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// Don't need actual contacts
	var contacts: [Contact.Attributes] = []

    override func viewDidLoad() {
        super.viewDidLoad()

		self.view.backgroundColor = .white

		self.view.addSubview(tableView)
		tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "cell")

		self.tableView.dataSource = self


		// TODO: Replace with APIClient
		session.dataTask(with: requestBuilder.request(for: .getContacts)!) { [weak self] (data, response, error) in
			guard let data = data else {
				return
			}
			let decoder = JSONDecoder()
			print(String.init(data: data, encoding: .utf8))
			DispatchQueue.main.sync {
				self?.contacts = try! decoder.decode(Array<Contact.Attributes>.self, from: data)
				self?.tableView.reloadData()
			}
		}.resume()


        // Do any additional setup after loading the view.
    }

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contacts.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let contact = contacts[indexPath.row]
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ContactTableViewCell else {
			fatalError("Cannot dequeue cell")
		}

		cell.configure(with: contact, imageDownloader: imageDownloader)
		return cell
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.frame = view.bounds
	}

}



let sampleContactJSON = """
[{
"id": 1402,
"first_name": "000sjhdfydfv",
"last_name": "shjgdvahdfg",
"profile_pic": "https://contacts-app.s3-ap-southeast-1.amazonaws.com/contacts/profile_pics/000/001/402/original/Screen_Shot_2018-03-29_at_11.43.36.png?1524763798",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/1402.json"
},
{
"id": 1368,
"first_name": "12345",
"last_name": "anwarm",
"profile_pic": "/images/missing.png",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/1368.json"
},
{
"id": 1379,
"first_name": "12imran",
"last_name": "Naseem",
"profile_pic": "/images/missing.png",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/1379.json"
},
{
"id": 1314,
"first_name": "aaaaa",
"last_name": "qqqqqqqqqqqqq",
"profile_pic": "/images/missing.png",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/1314.json"
},
{
"id": 1194,
"first_name": "Amaaa",
"last_name": "Amhhhh",
"profile_pic": "/images/missing.png",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/1194.json"
},
{
"id": 1204,
"first_name": "Amitabh",
"last_name": "Bachchan",
"profile_pic": "/images/missing.png",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/1204.json"
},
{
"id": 1444,
"first_name": "Anak",
"last_name": "Ayam",
"profile_pic": "/images/missing.png",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/1444.json"
},
{
"id": 1443,
"first_name": "dfdf",
"last_name": "fsdf",
"profile_pic": "/images/missing.png",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/1443.json"
},
{
"id": 42,
"first_name": "jskadn",
"last_name": "kdslajd",
"profile_pic": "https://contacts-app.s3-ap-southeast-1.amazonaws.com/contacts/profile_pics/000/000/042/original/arrow_down.png?1494582973",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/42.json"
},
{
"id": 1363,
"first_name": "Managam",
"last_name": "Sil",
"profile_pic": "/images/missing.png",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/1363.json"
},
{
"id": 1361,
"first_name": "Managam",
"last_name": "Silalahi",
"profile_pic": "/images/missing.png",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/1361.json"
},
{
"id": 1323,
"first_name": "Nadine",
"last_name": "siregar ",
"profile_pic": "/images/missing.png",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/1323.json"
},
{
"id": 993,
"first_name": "Nagesh",
"last_name": "Degil",
"profile_pic": "https://contacts-app.s3-ap-southeast-1.amazonaws.com/contacts/profile_pics/000/000/993/original/profile.png?1506078704",
"favorite": true,
"url": "https://gojek-contacts-app.herokuapp.com/contacts/993.json"
}]
""".data(using: .utf8)!
