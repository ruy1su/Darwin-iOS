//
//  EpisodeTableViewDataSource.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/13/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

@objc
protocol EpisodeSelectionObserver: class {
	func selected(_ episode: EpisodeDataStack, on: IndexPath)
}


class EpisodeTableViewDataSource: NSObject {
	
	var dataStack: EpisodeDataStack
	var managedTable: UITableView
	var currentPodcast: Podcast
	
	init(tableView: UITableView, podcast: Podcast) {
		dataStack = EpisodeDataStack()
		managedTable = tableView
		currentPodcast = podcast
		super.init()
		managedTable.dataSource = self
		managedTable.delegate = self
	}
	
	private var selectionObservers = NSHashTable<EpisodeSelectionObserver>.weakObjects()
	
	func registerSelectionObserver(observer: EpisodeSelectionObserver) {
		selectionObservers.add(observer)
	}
	
	func episode(at index: Int) -> Episode {
		let realindex = index % dataStack.allEps.count
		return dataStack.allEps[realindex]
	}
	
	func load() {
		let pid = currentPodcast.pid
		guard let homeUrl = URL(string: APIKey.sharedInstance.getApi(key:"/api_episode/\(pid ?? 2)")) else { return }
		URLSession.shared.dataTask(with: homeUrl) { (data, response
			, error) in
			
			guard let data = data else { return }
			do {
				let decoder = JSONDecoder()
				let apiHomeData = try decoder.decode(Array<Episode>.self, from: data)
				print(apiHomeData.count, "\n++++++ This is api episode data number for selected podcast ++++++\n")
				DispatchQueue.main.async {
					self.dataStack.load(episodes: apiHomeData) { [weak self] success in
						self?.managedTable.reloadData()
						self?.setMediaForPlayer(datastack: (self?.dataStack)!, currentPodcastMedia: (self?.currentPodcast.mediaURL)!)
						
					}
				}
			} catch let err {
				print("Error, Couldnt load api data", err)
			}
			}.resume()
		
	}
	
	func setMediaForPlayer(datastack: EpisodeDataStack, currentPodcastMedia: URL){
		let currentPodcastMedia = currentPodcastMedia
		Alamofire.request((currentPodcastMedia.absoluteString)).responseString { response in
			let data = response.result.value!
			let matched = Helper.matches(for: "(http(s?):)([/|.|\\w|\\s|-])*\\.(?:mp3)", in: String(data))
			var unique = [String]()
			for s in matched{
				if !unique.contains(s){
					unique.append(s)
				}
			}
			print(unique, unique.count)
			datastack.setMediaURL(mediaURLArr: unique)
		}
	}
	
	
}

extension EpisodeTableViewDataSource: UITableViewDataSource, UITableViewDelegate{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataStack.allEps.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// Setting Artist for Episode
		dataStack.setArtist(podcast: currentPodcast, on: indexPath)
		// Configure Cells
		let cell = tableView.dequeueReusableCell(withIdentifier: "epi_cell", for: indexPath) as? EpisodeListTableViewCell
		let episode: Episode = dataStack.allEps[indexPath.row]
		// Displaying values
		cell?.titleLabel.text = episode.title
		cell?.artistLabel.text = episode.artist
		cell?.desLabel.text = episode.info
		
		cell?.desLabel.numberOfLines = 0
		cell?.desLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
		
		return cell!
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		for observer:EpisodeSelectionObserver in self.selectionObservers.allObjects {
			observer.selected(dataStack, on: indexPath)
		}
	}
	
}
