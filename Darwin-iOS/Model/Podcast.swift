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
	let pid: Int?
	let artist: String?
	let mediaURL: URL?
	let coverArtURL: URL?
	let category: String?
	private enum CodingKeys: String, CodingKey {
		case title
		case pid
		case artist
		case category
		case mediaURL = "mediaURL"
		case coverArtURL = "coverArtURL"
	}
}

