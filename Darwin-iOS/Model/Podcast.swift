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
	let title: String?
	var pid: Int?
	let artist: String?
	var mediaURL: URL?
	let coverArtURL: URL?
	private enum CodingKeys: String, CodingKey {
		case title
		case pid
		case artist
		case mediaURL = "mediaUrl"
		case coverArtURL = "coverArtURL"
	}
}

