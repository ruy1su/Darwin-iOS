//
//  EpisodeListViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/12/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class EpisodeListViewController: UIViewController, HearThisPlayerHolder, EpisodeSelectionObserver, HearThisPlayerObserver {

	var currentPodcast: Podcast?
	var datasource: EpisodeTableViewDataSource!
	var hearThisPlayer: HearThisPlayerType? {
		didSet {
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	@IBOutlet weak var episodeListHeaderView: EpisodeListHeaderView!
	@IBOutlet weak var episodeTableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		print(currentPodcast as Any)
		print(" ++++++ This is selected podcast ++++++ \n")
		datasource = EpisodeTableViewDataSource(tableView: episodeTableView, podcast: currentPodcast!)
		datasource.load()
		datasource.registerSelectionObserver(observer: self)
		episodeListHeaderView.podcast = currentPodcast
	}

	func selected(_ episodeStack: EpisodeDataStack, on: IndexPath) {
		hearThisPlayer?.stop()
		episodeStack.setCoverArt(podcast: currentPodcast!, on: on)
		hearThisPlayer?.play(episodeStack.allEps[on.row])
		print("Print Selected Image for info ======->", episodeStack.allEps[on.row].coverArtURL ?? "ok")
		self.performSegue(withIdentifier: "unWind", sender: self)
	}
}
