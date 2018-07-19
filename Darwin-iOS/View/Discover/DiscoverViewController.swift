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


class DiscoverViewController: UIViewController, TrackSubscriber, HearThisPlayerHolder, PodcastSelectionObserver, HearThisPlayerObserver {

	// MARK: - Properties
	var datasource: PodcastCollectionDatasource!
	var episodeListViewController: EpisodeListViewController?
	var currentPodcast: Podcast?
	var currentEpisode: Episode?
	let searchController = UISearchController(searchResultsController: nil)
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
		
		// Initialize Search Controller
		searchController.searchResultsUpdater = self as? UISearchResultsUpdating
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Podcast/Episodes"
		navigationItem.searchController = searchController
		definesPresentationContext = true
		
		// Configure Datasource
		datasource = PodcastCollectionDatasource(collectionView: collectionView)
		datasource.load()
		datasource.registerSelectionObserver(observer: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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

