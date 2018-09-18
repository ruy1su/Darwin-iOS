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
	private var pid: Int?
	private var artist: String?
	private var mediaURL: URL?
	private var coverArtURL: URL?
	private var category: String?
	private var url: String?
	
	func build() -> Podcast? {
		guard let title = title,
			let artist = artist else {
				return nil
		}
		
		return Podcast(title: title, pid: pid, artist: artist, mediaURL: mediaURL, coverArtURL: coverArtURL, category: category, url: url)
	}
	
	func with(title: String?) -> Self {
		self.title = title
		return self
	}
	
	func with(pid: Int?) -> Self {
		self.pid = pid
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
	
	func with(category: String?) -> Self {
		self.category = category
		return self
	}
	func with(url: String?) -> Self {
		self.url = url
		return self
	}
}
