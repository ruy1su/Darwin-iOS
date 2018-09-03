//
//  LoadImage.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

extension UIImageView {
	func imageFromUrl(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
		contentMode = mode
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)
				else { return }
			DispatchQueue.main.async() {
				self.image = image
			}
			}.resume()
	}
	func imageFromUrlWithChangedSize(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
		contentMode = mode
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)?.resizeImage(targetSize: CGSize(width: 50, height: 50) )
				else { return }
			DispatchQueue.main.async() {
				self.image = image
			}
			}.resume()
	}
	func imageFromUrl(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
		guard let url = URL(string: link) else {
			let image = UIImage(named: "user")
			self.image = image
			return
		}
		imageFromUrl(url: url, contentMode: mode)
	}
}

extension Episode {
	func loadEpisodeImage(completion: @escaping ((UIImage?) -> (Void))) {
		guard let imageURL = coverArtURL,
			let file = try? Data(contentsOf: imageURL) else {
				return
		}
		DispatchQueue.global(qos: .background).async {
			let image = UIImage(data: file)
			DispatchQueue.main.async {
				completion(image)
			}
		}
	}
}

extension Podcast {
	func loadPodcastImage(completion: @escaping ((UIImage?) -> (Void))) {
		guard let imageURL = coverArtURL,
			let file = try? Data(contentsOf: imageURL) else {
				return
		}
		DispatchQueue.global(qos: .background).async {
			let image = UIImage(data: file)
			DispatchQueue.main.async {
				completion(image)
			}
		}
	}
}


