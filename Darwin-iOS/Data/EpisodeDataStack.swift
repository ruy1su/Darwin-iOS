//
//  EpisodeDataStack.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/13/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import CoreData
import FeedKit

enum EpisodeDataStackState {
	case unloaded
	case loaded
}

class EpisodeDataStack: NSObject {
	
	// MARK: - Properties
	private(set) var allEps: [Episode] = []
	
	func loadFeed(episodes: RSSFeed, completion: (Bool) -> Void){
		for episode in episodes.items! {
			let builder = EpisodeBuilder()
				.with(title: episode.title)
				.with(artist: episode.author)
				.with(pid: 0)
				.with(mediaURL: episode.link)
				.with(info: episode.description)
				.with(releaseDate: episode.pubDate?.description)
				.with(coverArtURL: episodes.image?.link)

			print(episode.media?.mediaBackLinks)
			if let episode = builder.build() {
				allEps.append(episode)
			}
			completion(true)

		}
	}
	
	func load(episodes: [Episode], completion: (Bool) -> Void){
		for episode in episodes {
			let builder = EpisodeBuilder()
				.with(title: episode.title)
				.with(artist: episode.artist)
				.with(pid: episode.pid)
				.with(mediaURL: episode.mediaURL?.absoluteString)
				.with(info: episode.info)
				.with(releaseDate: episode.releaseDate)
				.with(coverArtURL: episode.coverArtURL?.absoluteString)
			
			
			if let episode = builder.build() {
				allEps.append(episode)
			}
			completion(true)
		}
	}
	
	func setCoverArt(podcast: Podcast, on: IndexPath) {
		self.allEps[on.row].coverArtURL = podcast.coverArtURL
	}
	
	func setMediaURL(mediaURLArr: [String]){
		var i: Int = 0
		for url in mediaURLArr{
			if i < allEps.count{
				self.allEps[i].mediaURL? = URL(string: url)!
				i+=1
			}
		}
	}
}
