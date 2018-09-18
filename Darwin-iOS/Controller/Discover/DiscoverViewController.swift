//
//  DiscoverViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class DiscoverViewController: UIViewController, TrackSubscriber, HearThisPlayerHolder, HearThisPlayerObserver{
	// MARK: - Properties
	@IBOutlet weak var DiscoverTableView: UITableView!
	@IBAction func reload(_ sender: Any) {
		flag = true
		self.DiscoverTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
		self.DiscoverTableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
	}
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	
	var flag: Bool = false
	var collectionView: UICollectionView?
	var episodeListViewController: EpisodeListViewController?
	var dataStack = EpisodeDataStack()
	var currentPodcast: Podcast?
	var currentEpisode: Episode?
	var currentPodcastMedia: URL?
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
		let firstTodoEndpoint:String = APIKey.sharedInstance.getApi(key: "/api_trending/")
		Alamofire.request(firstTodoEndpoint).responseJSON { (response) in
			do{
				let apiHomeData = try JSONDecoder().decode(Array<Episode>.self, from: (response.data)!)
				print(apiHomeData)
				Alamofire.request((apiHomeData[0].mediaURL?.absoluteString)!).responseString { response in
					let data = response.result.value!
					let matched = Helper.matches(for: "(http(s?):)([/|.|\\w|\\s|-])*\\.(?:mp3)", in: String(data))
					self.dataStack.setMediaURL(mediaURLArr: matched.unique())
				}
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
		currentPodcastMedia = currentPodcast?.mediaURL
		performSegue(withIdentifier: "collection_to_table", sender: self)
		currentPodcast = nil
	}
}

extension DiscoverViewController: UISearchResultsUpdating, UISearchBarDelegate{
	
	func updateSearchResults(for searchController: UISearchController) {
		print("Press Keyboard")
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let dataStack = DataStack()
		self.search(dataStack: dataStack, searchBar: searchBar)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		if let searchResultsController = self.searchController.searchResultsController as? SearchResultTableViewController {
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
							searchResultsController.allArray = dataStack.allPods
							searchResultsController.array = Array(dataStack.allPods.prefix(5))
							searchResultsController.loadingData = false
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
		return 6+self.dataStack.allEps.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.row {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath)
			return cell
		case 1:
			if !sharedDarwinUser.loginStatus{
				let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath) as! NotifyLoginCell
				cell.title.text = "Login to Explore More"
				cell.title.textColor = UIColor.blue
				return cell
			}else{
				let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendationCell", for: indexPath) as! PodcsatCollectionCell
				cell.delegate = self
				if sharedDarwinUser.loginStatus && flag{
					cell.API = APIKey.sharedInstance.getApi(key:"/refresh_recommendation/\(sharedDarwinUser.baseUid)")
					cell.awakeFromNib()
					flag = false
				}
				return cell
			}
		case 2:
			let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell2", for: indexPath)
			return cell
		case 3:
			if !sharedDarwinUser.loginStatus{
				let cell = tableView.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath) as! NotifyLoginCell
				cell.title.text = "Login to Explore More"
				cell.title.textColor = UIColor.blue
				return cell
			}else{
				let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingRecommendationCell", for: indexPath) as! PodcsatCollectionCell
				cell.delegate = self
				if sharedDarwinUser.loginStatus{
					cell.API = APIKey.sharedInstance.getApi(key:"/refresh_recommendation_following/\(sharedDarwinUser.baseUid)")
					cell.awakeFromNib()
				}
				return cell
			}
		case 4:
			let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
			return cell
		case 5:
			let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! PodcsatCollectionCell
			cell.delegate = self
			cell.API = APIKey.sharedInstance.getApi(key:"/api_home")
			return cell
		default:
			let episode: Episode = dataStack.allEps[indexPath.row-6]
			let cell = EpisodeListTableViewCell(player: hearThisPlayer!, listItem: episode)
			
			UIGraphicsBeginImageContextWithOptions(CGSize(width: 50, height: 50), false, UIScreen.main.scale)
			cell.imageView!.imageFromUrlWithChangedSize(url: (episode.coverArtURL)!)
			cell.imageView!.clipsToBounds = true
			cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
		if editActionsForRowAt.row >= 5{
			let boring = UITableViewRowAction(style: .normal, title: "Boring") { action, index in
				print("Boring button tapped")
			}
			boring.backgroundColor = UIColor(rgb: 0xCFD8DC)
			let see = UITableViewRowAction(style: .normal, title: "Detail") { action, index in
				print("favorite button tapped")
				let episode: Episode = self.dataStack.allEps[editActionsForRowAt.row-5]
				let api: String = APIKey.sharedInstance.getApi(key: "/api_pod/\(episode.pid ?? 100)")
				self.loadPodFromEpisode(episode: episode, api: api)
			}
			see.backgroundColor = UIColor(rgb: 0x90CAF9)
			
			let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
				print("share button tapped")
			}
			share.backgroundColor = UIColor(rgb: 0xA5D6A7)
			return [boring, share, see]

		}
		else{
			return []
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath.row > 5){
			hearThisPlayer?.stop()
			hearThisPlayer?.playItems(self.dataStack.allEps, firstItem: self.dataStack.allEps[indexPath.row - 6])
			self.DiscoverTableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.backgroundColor = UIColor(rgb: 0xECEFF1)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return 100
		case 1:
			return 150
		case 2:
			return 100
		case 3:
			return 150
		case 4:
			return 150
		case 5:
			return 300
		default:
			return 80
		}
	}
	
	func loadPodFromEpisode(episode: Episode, api: String) {
		let dataStack: DataStack = DataStack()
		guard let homeUrl = URL(string: api) else { return }
		URLSession.shared.dataTask(with: homeUrl) { (data, response
			, error) in
			guard let data = data else { return }
			do {
				let decoder = JSONDecoder()
				let apiHomeData = try decoder.decode(Array<Podcast>.self, from: data)
				print(apiHomeData[0],"\n ++++++ Fetched podcast data from backend ++++++\n")
				DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {
					dataStack.loadPod(podcasts: apiHomeData) { [weak self] success in
						self?.currentPodcast = dataStack.allPods[0]
						self?.alert(message: episode.info!, title: episode.title!, action1: "Done", action2: "More", podcast: dataStack.allPods[0], controller: self!)
					}
				}
			} catch let err {
				print("Error, Couldnt load api data", err)
			}
			}.resume()
	}
	
}

