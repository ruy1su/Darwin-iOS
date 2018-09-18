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
	//	private(set)
	var allPods: [Podcast] = []
	
	func load(dictionary: [String: Any], completion: (Bool) -> Void) {
		if let podcasts = dictionary["Podcasts"] as? [[String: Any]] {
			for podcastDictionary in podcasts {
				let builder = PodcastBuilder()
					.with(title: podcastDictionary["title"] as? String)
					.with(artist: podcastDictionary["artist"] as? String)
					.with(pid: podcastDictionary["pid"] as? Int)
					.with(mediaURL: podcastDictionary["mediaURL"] as? String)
					.with(coverArtURL: podcastDictionary["coverArtURL"] as? String)
					.with(category: podcastDictionary["category"] as? String)
					.with(url: podcastDictionary["url"] as? String)
				if let podcast = builder.build() {
					allPods.append(podcast)
				}
			}
			completion(true)
		} else {
			completion(false)
		}
	}
	
	func loadPod(podcasts: [Podcast], completion: (Bool) -> Void){
		allPods = []
		for podcast in podcasts {
			let builder = PodcastBuilder()
				.with(title: podcast.title)
				.with(artist: podcast.artist)
				.with(pid: podcast.pid)
				.with(mediaURL: podcast.mediaURL?.absoluteString)
				.with(coverArtURL: podcast.coverArtURL?.absoluteString)
				.with(category: podcast.category)
				.with(url: podcast.url)
			if let podcast = builder.build() {
				allPods.append(podcast)
			}
			completion(true)
		}
	}
	func loadPod(podcasts: [Podcast]){
		allPods = []
		for podcast in podcasts {
			let builder = PodcastBuilder()
				.with(title: podcast.title)
				.with(artist: podcast.artist)
				.with(pid: podcast.pid)
				.with(mediaURL: podcast.mediaURL?.absoluteString)
				.with(coverArtURL: podcast.coverArtURL?.absoluteString)
				.with(category: podcast.category)
				.with(url: podcast.url)
			if let podcast = builder.build() {
				allPods.append(podcast)
			}
		}
	}
}
