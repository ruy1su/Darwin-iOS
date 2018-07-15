//
//  EpisodeListViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/12/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class EpisodeListViewController: UIViewController, EpisodeSubscriber, PodcastSubscriber {
	var currentEpisode: Episode?
	var currentPodcast: Podcast?
	var episodesList = [Episode]()
	var datasource: EpisodeTableViewDataSource!
	var floatingPlayer: FloatingPlayerViewController?

	@IBOutlet weak var episodeTableView: UITableView!


	override func viewDidLoad() {
		super.viewDidLoad()
		print(currentPodcast as Any)
		print("what")

		datasource = EpisodeTableViewDataSource(tableView: episodeTableView, podcast: currentPodcast!)
		datasource.load()
		episodeTableView.delegate = self 
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? FloatingPlayerViewController {
			floatingPlayer = destination
			floatingPlayer?.delegate = self
		}
	}
}

// MARK: - FloatingPlayerDelegate
extension EpisodeListViewController: FloatingPlayerDelegate {
	
	func expandPodcast(podcast: Podcast, episode: Episode) {
		guard let expandingPlayer = storyboard?.instantiateViewController(withIdentifier: "ExpandingPlayerViewController") as? ExpandingPlayerViewController else {
			assertionFailure("No view controller ID ExpandingPlayerViewController in storyboard")
			return
		}
		
		expandingPlayer.backingImage = view.makeSnapshot()
		expandingPlayer.currentPodcast = podcast
		expandingPlayer.currentEpisode = episode
		expandingPlayer.sourceView = floatingPlayer
		if let tabBar = tabBarController?.tabBar {
			expandingPlayer.tabBarImage = tabBar.makeSnapshot()
		}
		present(expandingPlayer, animated: false)
	}
}
// MARK: - UICollectionViewDelegate
extension EpisodeListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let currentEpisode = datasource.episode(at: indexPath.row)
		floatingPlayer?.configure(episode: currentEpisode, podcast: currentPodcast)
//		print(currentEpisode)
	}
	
}
