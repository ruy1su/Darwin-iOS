//
//  DiscoverViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import Alamofire

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
	var dataStack = EpisodeDataStack()
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
		
		loadTrendingEpisode()
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
	func loadTrendingEpisode() {
		let firstTodoEndpoint:String = APIKey.sharedInstance.getApi(key: "/api_episode_trending/")
		Alamofire.request(firstTodoEndpoint).responseJSON { (response) in
			do{
				let apiHomeData = try JSONDecoder().decode(Array<Episode>.self, from: (response.data)!)
				self.dataStack.load(episodes: apiHomeData) { success in
					self.DiscoverTableView.reloadData()
				}
			}catch {
				print("Unable to load data: \(error)")
			}
		}
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
		self.search(dataStack: dataStack, searchBar: searchBar)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		if let searchResultsController = self.searchController.searchResultsController as?SearchResultTableViewController {
				searchResultsController.array = []
				searchResultsController.tableView.reloadData()
		}
	}
	func search(dataStack: DataStack, searchBar: UISearchBar) {
		if let search = searchBar.text{
			let firstTodoEndpoint:String = APIKey.sharedInstance.getApi(key: "/api_search/\(search)")
			Alamofire.request(firstTodoEndpoint).responseJSON { (response) in
				do{
					let apiHomeData = try JSONDecoder().decode(Array<Podcast>.self, from: (response.data)!)
					dataStack.loadPod(podcasts: apiHomeData) { success in
						if let searchResultsController = self.searchController.searchResultsController as? SearchResultTableViewController {
							searchResultsController.array = dataStack.allPods
							searchResultsController.hearThisPlayer = self.hearThisPlayer
							searchResultsController.tableView.reloadData()
						}
					}
				}catch {
					print("Unable to load data: \(error)")
				}
			}
		}
	}
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3+self.dataStack.allEps.count+1
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
		case 2:
			let cell = tableView.dequeueReusableCell(withIdentifier: "footcell", for: indexPath)
			return cell
		case 3+self.dataStack.allEps.count:
			let cell = tableView.dequeueReusableCell(withIdentifier: "footcell", for: indexPath)
			return cell
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: "home_epi_cell", for: indexPath) as? EpisodeListTableViewCell
			let episode: Episode = self.dataStack.allEps[indexPath.row-3]
			// Displaying values
			cell?.titleLabel.text = episode.title
			cell?.artistLabel.text = episode.artist
			cell?.desLabel.text = episode.info
			cell?.desLabel.numberOfLines = 0
			cell?.desLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
			return cell!
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		hearThisPlayer?.stop()
		hearThisPlayer?.play(self.dataStack.allEps[indexPath.row - 3])
		print("Print Selected Image for info ======->", dataStack.allEps[indexPath.row - 3].coverArtURL ?? "ok")
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return 150
		case 1:
			return 300
		case 2:
			return 150
		case -1:
			return 150
		default:
			return 200
		}
	}
}

