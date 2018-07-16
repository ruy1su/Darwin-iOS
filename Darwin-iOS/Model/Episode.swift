//
//  Episode.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/12/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

struct Episode:Codable {
	
	// MARK: - Properties
	var pid: Int?
	var podcast: String?
	let title: String?
	let releaseDate: String?
	let info: String?

	var eid: Int?
	let artist: String?
	var mediaURL: URL?
	var coverArtURL: URL?

	private enum CodingKeys: String, CodingKey {
		case title
		case eid
		case pid
		case artist
		case podcast = "podcast"
		case info = "info"
		case mediaURL = "mediaURL"
		case releaseDate = "release_date"
		case coverArtURL = "coverArtURL"
	}
}
