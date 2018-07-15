//
//  PodcastSubscriber.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import Foundation

protocol PodcastSubscriber: class {
	var currentPodcast: Podcast? { get set }
}

protocol EpisodeSubscriber: class {
	var currentEpisode: Episode? { get set }
}

