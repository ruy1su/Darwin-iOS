//
//  EpisodeListViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/12/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class EpisodeListViewController: UIViewController, TrackSubscriber, HearThisPlayerHolder, EpisodeSelectionObserver, HearThisPlayerObserver {

	var currentEpisode: Episode?
	var currentPodcast: Podcast?
	var datasource: EpisodeTableViewDataSource!
	var hearThisPlayer: HearThisPlayerType? {
		didSet {
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	@IBOutlet weak var episodeTableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		print(currentPodcast as Any)
		print("what")

		datasource = EpisodeTableViewDataSource(tableView: episodeTableView, podcast: currentPodcast!)
		datasource.load()
		datasource.registerSelectionObserver(observer: self)
	}

	func selected(_ episodeStack: EpisodeDataStack, on: IndexPath) {
		hearThisPlayer?.stop()
		episodeStack.setCoverArt(podcast: currentPodcast!, on: on)
		hearThisPlayer?.play(episodeStack.allEps[on.row])
		print(episodeStack.allEps[on.row], "========", episodeStack.allEps[on.row].coverArtURL ?? "ok")
	}
}
