//
//  EpisodeBuilder.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/13/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import Foundation

class EpisodeBuilder: NSObject {
	
	// MARK: - Properties
	private var title: String?
	private var pid: Int?
	private var eid: Int?
	private var info: String?
	private var artist: String?
	private var podcast: String?
	private var mediaURL: URL?
	private var releaseDate: String?
	private var coverArtURL: URL?
	
	func build() -> Episode? {
		guard let mediaURL = mediaURL else {
				return nil
		}
		
		return Episode(pid: pid, podcast:podcast, title: title, releaseDate: releaseDate, info: info, eid: eid, artist: artist, mediaURL: mediaURL, coverArtURL: coverArtURL)
	}
	
	func with(title: String?) -> Self {
		self.title = title
		return self
	}
	
	func with(pid: Int?) -> Self {
		self.pid = pid
		return self
	}
	
	func with(eid: Int?) -> Self {
		self.eid = eid
		return self
	}
	
	func with(artist: String?) -> Self {
		self.artist = artist
		return self
	}
	
	func with(mediaURL url: String?) -> Self {
		guard let urlstring = url else {
			return self
		}
		
		self.mediaURL = URL(string: urlstring)
		return self
	}
	
	func with(info: String?) -> Self {
		self.info = info
		return self
	}

	func with(podcast: String?) -> Self{
		self.podcast = podcast
		return self
	}
	//
//	func with(duration: TimeInterval?) -> Self {
//		self.duration = duration ?? 0
//		return self
//	}
//
	func with(coverArtURL url: String?) -> Self {
		guard let urlstring = url else {
			return self
		}
		
		self.coverArtURL = URL(string: urlstring)
		return self
	}
	func with(releaseDate: String?) -> Self{
		self.releaseDate = releaseDate
		return self
	}
}



