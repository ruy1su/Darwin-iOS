//
//  Podcast.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

struct Podcast {
	
	// MARK: - Properties
	let title: String
	var duration: TimeInterval = 0
	let artist: String
	var mediaURL: URL?
	var coverArtURL: URL?
}
