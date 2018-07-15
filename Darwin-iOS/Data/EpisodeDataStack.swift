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
		//		if let podcasts = podcasts as? [Podcast] {
		for episode in episodes {
			let builder = EpisodeBuilder()
				.with(title: episode.title)
				.with(artist: episode.artist)
				.with(pid: episode.pid)
				.with(mediaURL: episode.mediaURL?.absoluteString)
				.with(info: episode.info)
				.with(releaseDate: episode.releaseDate)
				.with(info: episode.info)
			
			if let episode = builder.build() {
				allEps.append(episode)
			}
			completion(true)
		}
	}
}
