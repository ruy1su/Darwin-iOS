//
//  DiscoverViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class PodcastCell: UICollectionViewCell {
	
	// MARK: - IBOutlets
	@IBOutlet weak var coverArt: UIImageView!
	@IBOutlet weak var podcastTitle: UILabel!
	@IBOutlet weak var artistName: UILabel!
	
}


class DiscoverViewController: UIViewController, TrackSubscriber, HearThisPlayerHolder, PodcastSelectionObserver {

	// MARK: - Properties
	var datasource: PodcastCollectionDatasource!
//	var floatingPlayer: FloatingPlayerViewController?
	var episodeListViewController: EpisodeListViewController?
	var currentPodcast: Podcast?
	var currentEpisode: Episode?
	@IBOutlet weak var collectionView: UICollectionView!
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	func selected(_ podcast: DataStack, on: IndexPath) {
		currentPodcast = podcast.allPods[on.row]
		performSegue(withIdentifier: "collection_to_table", sender: self)
		currentPodcast = nil
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		// Setting a cache threshold
		let memoryCapacity = 500 * 1024 * 1024
		let diskCapacity = 500 * 1024 * 1024
		let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myDiskPath")
		URLCache.shared = urlCache
		datasource = PodcastCollectionDatasource(collectionView: collectionView)
		datasource.load()
		datasource.registerSelectionObserver(observer: self)
		collectionView.delegate = self
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if let destination = segue.destination as? FloatingPlayerViewController {
//			floatingPlayer = destination
//			floatingPlayer?.delegate = self
//		}
		if let destiantion =  segue.destination as? HearThisPlayerHolder {
			destiantion.hearThisPlayer = hearThisPlayer
		}
		if let indexPath = (collectionView?.indexPathsForSelectedItems as [NSIndexPath]?)?.last {
			let controller = segue.destination as! EpisodeListViewController
			controller.currentPodcast = datasource.dataStack.allPods[indexPath.row]
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension DiscoverViewController: HearThisPlayerObserver {
	
}

// MARK: - FloatingPlayerDelegate
extension DiscoverViewController: FloatingPlayerDelegate {

	func expandEpisode(episode: Episode) {
		guard let expandingPlayer = storyboard?.instantiateViewController(withIdentifier: "ExpandingPlayerViewController") as? ExpandingPlayerViewController else {
			assertionFailure("No view controller ID ExpandingPlayerViewController in storyboard")
			return
		}

		expandingPlayer.backingImage = view.makeSnapshot()
//		expandingPlayer.currentPodcast = podcast
//		expandingPlayer.sourceView = floatingPlayer
		if let tabBar = tabBarController?.tabBar {
			expandingPlayer.tabBarImage = tabBar.makeSnapshot()
		}
		present(expandingPlayer, animated: false)
	}
}

// MARK: - UICollectionViewDelegate
//extension DiscoverViewController: UICollectionViewDelegate {
//
//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		currentPodcast = datasource.podcast(at: indexPath.row)
//		floatingPlayer?.configure(podcast: currentPodcast)
//	}
//}
