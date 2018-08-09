//
//  EpisodeDataStack.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/13/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import CoreData

enum EpisodeDataStackState {
	case unloaded
	case loaded
}

class EpisodeDataStack: NSObject {
	
	// MARK: - Properties
	private(set) var allEps: [Episode] = []
	
	func load(episodes: [Episode], completion: (Bool) -> Void){
		for episode in episodes {
			let builder = EpisodeBuilder()
				.with(title: episode.title)
				.with(artist: episode.artist)
				.with(pid: episode.pid)
				.with(mediaURL: episode.mediaURL?.absoluteString)
				.with(info: episode.info)
				.with(releaseDate: episode.releaseDate)
				.with(info: episode.info)
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
	
	func setArtist(podcast: Podcast, on: IndexPath)  {
		self.allEps[on.row].artist = podcast.artist
	}
	
	func setMediaURL(mediaURLArr: [String]){
		var i: Int = 0
//		print(mediaURLArr.count)
//		print(self.allEps.count)
		for url in mediaURLArr{
			if i < allEps.count{
				self.allEps[i].mediaURL? = URL(string: url)!
				i+=1
			}
		}
	}
}
