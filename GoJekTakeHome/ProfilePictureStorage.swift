//
//  ProfilePictureStorage.swift
//  GoJekTakeHomeTests_iOS
//
//  Created by Robin Malhotra on 06/05/18.
//

import UIKit

class ProfilePictureDownloader {

	let session: URLSession

	var downloadedImages: [URL: UIImage] = [:]
	var downloadsInProgress: [URL: URLSessionDataTask] = [:]

	init(session: URLSession = .shared) {
		self.session = session
	}

	func getImage(for url: URL, onGettingImage completion: @escaping (UIImage) -> Void) {
		if let image = downloadedImages[url] {
			completion(image)
		} else {
			let task = session.dataTask(with: url) { [weak self] (data, response, error) in
				if let image = data.flatMap({ UIImage.init(data: $0) }) {
					DispatchQueue.main.sync {
						self?.downloadsInProgress.removeValue(forKey: url)
						self?.downloadedImages[url] = image
						completion(image)
					}
				}
			}

			task.resume()
		}
	}
}
