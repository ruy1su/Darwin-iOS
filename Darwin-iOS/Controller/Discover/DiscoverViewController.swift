//
//  DiscoverViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, TrackSubscriber, HearThisPlayerHolder, HearThisPlayerObserver{
	// MARK: - Properties
	@IBOutlet weak var DiscoverTableView: UITableView!
	
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	
	var collectionView: UICollectionView?
	var episodeListViewController: EpisodeListViewController?
	var currentPodcast: Podcast?
	var currentEpisode: Episode?
	var searchController = UISearchController(searchResultsController: SearchResultTableViewController())

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Initialize Search Controller
		searchController = UISearchController(searchResultsController: storyboard?.instantiateViewController(withIdentifier: "SearchResultTableVC"))
		searchController.obscuresBackgroundDuringPresentation = true
		searchController.searchResultsUpdater = self
		searchController.searchBar.placeholder = "Search Podcast/Episodes"
		navigationItem.searchController = searchController
		definesPresentationContext = true
		
		// Setup the Scope Bar
		searchController.searchBar.scopeButtonTitles = ["All Podcasts", "Your Collection"]
		searchController.searchBar.delegate = self
		
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
	}
}
extension DiscoverViewController:SelectedCollectionItemDelegate{
	// MARK: - Implement Delegate for Collection Cell Seletion
	func selectedCollectionItem(podcast: DataStack, index: IndexPath) {
		currentPodcast = podcast.allPods[index.row]
		performSegue(withIdentifier: "collection_to_table", sender: self)
		currentPodcast = nil
	}
}

extension DiscoverViewController: UISearchResultsUpdating, UISearchBarDelegate{
	
	func updateSearchResults(for searchController: UISearchController) {
		print("Press Keyboard")
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { //Ugly Search
		let dataStack = DataStack()
		if let search = searchBar.text{
			guard let homeUrl = URL(string: "http://ec2-18-219-52-58.us-east-2.compute.amazonaws.com/api_search/\(search)") else { return }
			URLSession.shared.dataTask(with: homeUrl) { (data, response
				, error) in
				guard let data = data else { return }
				do {
					let decoder = JSONDecoder()
					let apiHomeData = try decoder.decode(Array<Podcast>.self, from: data)
					print("\n ++++++ Search Sucess@@@@ ++++++\n")
					DispatchQueue.main.async {
						dataStack.loadPod(podcasts: apiHomeData) { success in
							if let searchResultsController = self.searchController.searchResultsController as? SearchResultTableViewController {
								searchResultsController.array = dataStack.allPods
								searchResultsController.hearThisPlayer = self.hearThisPlayer
								searchResultsController.tableView.reloadData()
							}
						}
					}
				} catch let err {
					print("Error, Couldnt load api data", err)
				}
				}.resume()
		}
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		if let searchResultsController = self.searchController.searchResultsController as?SearchResultTableViewController {
				searchResultsController.array = []
				searchResultsController.tableView.reloadData()
		}
	}
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
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
			let cell = tableView.dequeueReusableCell(withIdentifier: "footcell", for: indexPath)
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

