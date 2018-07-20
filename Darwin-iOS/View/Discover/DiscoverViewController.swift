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

class DiscoverViewController: UIViewController, TrackSubscriber, HearThisPlayerHolder, HearThisPlayerObserver, SelectedCollectionItemDelegate{
	// MARK: - Implement Delegate for Collection Cell Seletion
	func selectedCollectionItem(podcast: DataStack, index: IndexPath) {
		currentPodcast = podcast.allPods[index.row]
		performSegue(withIdentifier: "collection_to_table", sender: self)
		currentPodcast = nil
	}

	// MARK: - Properties
	var collectionView: UICollectionView?
	var episodeListViewController: EpisodeListViewController?
	var currentPodcast: Podcast?
	var currentEpisode: Episode?
	let searchController = UISearchController(searchResultsController: nil)
	

	@IBOutlet weak var DiscoverTableView: UITableView!
	
	
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Initialize Search Controller
		searchController.searchResultsUpdater = self as? UISearchResultsUpdating
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Podcast/Episodes"
		navigationItem.searchController = searchController
		definesPresentationContext = true
		
		// Setup the Scope Bar
		searchController.searchBar.scopeButtonTitles = ["All Podcasts", "Your Collection"]
		searchController.searchBar.delegate = self as? UISearchBarDelegate
		
		// Configure Datasource
		DiscoverTableView.dataSource = self
		DiscoverTableView.delegate = self
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destiantion =  segue.destination as? HearThisPlayerHolder {
			destiantion.hearThisPlayer = hearThisPlayer
		}
		if let destiantion =  segue.destination as? EpisodeListViewController {
			destiantion.currentPodcast = currentPodcast
		}

	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
			return cell
		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! PodcsatCollectionCell
			 cell.delegate = self
			return cell
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
			return cell
		}
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return 150
		case 1:
			return 300
		case 2:
			return 150
		default:
			return UITableViewAutomaticDimension
		}
	}
}
class Constant {
	static let totalItem: CGFloat = 20
	
	static let column: CGFloat = 3
	
	static let minLineSpacing: CGFloat = 1.0
	static let minItemSpacing: CGFloat = 1.0
	
	static let offset: CGFloat = 1.0 // TODO: for each side, define its offset
	
	static func getItemWidth(boundWidth: CGFloat) -> CGFloat {
		
		let totalWidth = boundWidth - (offset + offset) - ((column - 1) * minItemSpacing)
		
		return totalWidth / column
	}
}

