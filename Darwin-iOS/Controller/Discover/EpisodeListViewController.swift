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
	var flag: Bool = true
	@IBOutlet weak var height: NSLayoutConstraint!
	@IBOutlet weak var episodeListHeaderView: EpisodeListHeaderView!
	@IBOutlet weak var navBar: UINavigationBar!
	@IBOutlet weak var episodeTableView: UITableView!

	@IBAction func dismiss(_ sender: Any) {
		self.performSegue(withIdentifier: "unWind", sender: self)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		if flag{
			self.navBar.removeFromSuperview()
			height.constant = 0
		}
		print(currentPodcast as Any,"\n ++++++ This is selected podcast ++++++ \n")
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
	}
}
