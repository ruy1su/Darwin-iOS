//
//  Cache.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/29/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import SwiftyJSON

class Cache: NSObject {
	static let sharedInstance = Cache()
	
	private var episodeCache: [String: Episode]!
	private var podcastCache: [String: Podcast]!
	private var imageCache: [String: UIImage]!
	
	private override init() {
		// TODO: in future maybe store cache!
		episodeCache = [:]
		podcastCache = [:]
		imageCache = [:]
	}
	
	func reset() {
		episodeCache = [:]
		imageCache = [:]
		podcastCache = [:]
	}
	
//	func update(episodeJson: JSON) -> Episode {
//		let id = episodeJson["id"].stringValue
//		if let episode = episodeCache[id] {
//			// Update current episode object to maintain living object
//			episode.update(json: episodeJson)
//			return episode
//		} else {
//			let episode = Episode(json: episodeJson)
//			episodeCache[id] = episode
//			return episode
//		}
//	}
	
	func update(imageURL: URL) -> UIImage {
		let id = imageURL.absoluteString
		if let image = imageCache[id] {
			return image
		} else {
			let file = try? Data(contentsOf: imageURL)
			let image = UIImage(data: file!)
			imageCache[id] = image
			return image!
		}
	}
}
