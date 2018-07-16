//
//  EpisodeTableViewDataSource.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/13/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

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
		guard let homeUrl = URL(string: "http://ec2-18-219-52-58.us-east-2.compute.amazonaws.com:5000/api_episode/\(pid ?? 2)") else { return }
		URLSession.shared.dataTask(with: homeUrl) { (data, response
			, error) in
			
			guard let data = data else { return }
			do {
				let decoder = JSONDecoder()
				let apiHomeData = try decoder.decode(Array<Episode>.self, from: data)
				print(apiHomeData, "+++++++++\n")
				DispatchQueue.main.async {
					self.dataStack.load(episodes: apiHomeData) { [weak self] success in
						self?.managedTable.reloadData()
					}
				}
			} catch let err {
				print("Error, Couldnt load api data", err)
			}
			}.resume()
	}
}

extension EpisodeTableViewDataSource: UITableViewDataSource, UITableViewDelegate{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataStack.allEps.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "epi_cell", for: indexPath) as? EpisodeListTableViewCell
		let episode: Episode
		episode = dataStack.allEps[indexPath.row]
		
		//displaying values
		cell?.titleLabel.text = episode.title
		cell?.artistLabel.text = episode.artist
		cell?.desLabel.text = episode.info
		
		return cell!
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		for observer:EpisodeSelectionObserver in self.selectionObservers.allObjects {
			observer.selected(dataStack, on: indexPath)
			print(dataStack.allEps[indexPath.row],"=================")
		}
	}
	
}
