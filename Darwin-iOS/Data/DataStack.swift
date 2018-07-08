//
//  DataStack.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import CoreData

enum DataStackState {
	case unloaded
	case loaded
}

class DataStack: NSObject {
	
	// MARK: - Properties
	private(set) var allPods: [Podcast] = []
	
	func load(dictionary: [String: Any], completion: (Bool) -> Void) {
		if let podcasts = dictionary["Podcasts"] as? [[String: Any]] {
			for podcastDictionary in podcasts {
				let builder = PodcastBuilder()
					.with(title: podcastDictionary["title"] as? String)
					.with(artist: podcastDictionary["artist"] as? String)
					.with(duration: podcastDictionary["duration"] as? TimeInterval)
					.with(mediaURL: podcastDictionary["mediaURL"] as? String)
					.with(coverArtURL: podcastDictionary["coverArtURL"] as? String)
				if let podcast = builder.build() {
					allPods.append(podcast)
				}
			}
			completion(true)
		} else {
			completion(false)
		}
	}
}
