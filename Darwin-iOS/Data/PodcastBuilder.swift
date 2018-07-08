//
//  PodcastBuilder.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import Foundation

class PodcastBuilder: NSObject {
	
	// MARK: - Properties
	private var title: String?
	private var duration: TimeInterval = 0
	private var artist: String?
	private var mediaURL: URL?
	private var coverArtURL: URL?
	
	func build() -> Podcast? {
		guard let title = title,
			let artist = artist else {
				return nil
		}
		
		return Podcast(title: title, duration: duration, artist: artist, mediaURL: mediaURL, coverArtURL: coverArtURL)
	}
	
	func with(title: String?) -> Self {
		self.title = title
		return self
	}
	
	func with(duration: TimeInterval?) -> Self {
		self.duration = duration ?? 0
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
	
	func with(coverArtURL url: String?) -> Self {
		guard let urlstring = url else {
			return self
		}
		
		self.coverArtURL = URL(string: urlstring)
		return self
	}
}
