//
//  PodcastSubscriber.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import Foundation

protocol TrackSubscriber: class {
	var currentPodcast: Podcast? { get set }
	var currentEpisode: Episode? { get set }
	
}

