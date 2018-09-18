//
//  EpisodeTableViewDataSource.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/13/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import Alamofire
import FeedKit

@objc
protocol EpisodeSelectionObserver: class {
	func selected(_ episode: EpisodeDataStack, on: IndexPath)
}

class EpisodeTableViewDataSource: NSObject, HearThisPlayerHolder, HearThisPlayerObserver {
	var hearThisPlayer: HearThisPlayerType? {
		didSet {
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	
	var dataStack: EpisodeDataStack
	var managedTable: UITableView
	var currentPodcast: Podcast
	
	init(tableView: UITableView, podcast: Podcast, player: HearThisPlayerType) {
		dataStack = EpisodeDataStack()
		managedTable = tableView
		currentPodcast = podcast
		hearThisPlayer = player
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
		let feedURL = URL(string: (self.currentPodcast.mediaURL?.absoluteString)!)!
		let parser = FeedParser(URL: feedURL)
		parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
			// Load Data then back to Main Thread
			guard let feed = result.rssFeed, result.isSuccess else {
				print(result.error as Any)
				return
			}
			DispatchQueue.main.async {
				// update the UI
				self.dataStack.loadFeed(episodes: feed) { [weak self] success in
					self?.managedTable.reloadData()
					self?.setMediaForPlayer(datastack: (self?.dataStack)!, currentPodcastMedia: (self?.currentPodcast.mediaURL)!)
				}
			}
		}
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
			datastack.setMediaURL(mediaURLArr: unique)
		}
	}
	
}



extension EpisodeTableViewDataSource: UITableViewDataSource, UITableViewDelegate{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataStack.allEps.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		dataStack.setCoverArt(podcast: currentPodcast, on: indexPath)
		let episode: Episode = dataStack.allEps[indexPath.row]
		let cell = EpisodeListTableViewCell(player: hearThisPlayer!, listItem: episode)
		cell.hearThisPlayer = self.hearThisPlayer
		
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 50, height: 50), false, UIScreen.main.scale)
		cell.imageView!.imageFromUrlWithChangedSize(url: (episode.coverArtURL)!)
		cell.imageView!.clipsToBounds = true
		cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		for observer:EpisodeSelectionObserver in self.selectionObservers.allObjects {
			observer.selected(dataStack, on: indexPath)
		}
		self.hearThisPlayer?.playItems(dataStack.allEps, firstItem: dataStack.allEps[indexPath.row])
		let cell = tableView.cellForRow(at: indexPath) as! EpisodeListTableViewCell
		cell.hearThisPlayer = self.hearThisPlayer
		cell.updateAccessoryView()
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
}
