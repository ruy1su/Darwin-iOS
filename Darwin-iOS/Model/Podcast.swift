//
//  Podcast.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

struct Podcast:Codable {
	
	// MARK: - Properties
	let coverArtURL: URL?
	let title: String?
	var duration: TimeInterval = 0
	let artist: String?
	var mediaURL: URL?
	private enum CodingKeys: String, CodingKey {
		case title
		case duration
		case artist
		case mediaURL = "mediaUrl"
		case coverArtURL = "coverArtURL"
	}
}

