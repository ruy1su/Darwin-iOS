//
//  PodcastCollectionDatasource.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class PodcastCollectionDatasource: NSObject {
	
	var dataStack: DataStack
	var managedCollection: UICollectionView
	
	init(collectionView: UICollectionView) {
		dataStack = DataStack()
		managedCollection = collectionView
		super.init()
		managedCollection.dataSource = self
	}
	
	func podcast(at index: Int) -> Podcast {
		let realindex = index % dataStack.allPods.count
		return dataStack.allPods[realindex]
	}
	
	func load() {
		guard let homeUrl = URL(string: "http://ec2-18-219-52-58.us-east-2.compute.amazonaws.com/api_home") else { return }
		URLSession.shared.dataTask(with: homeUrl) { (data, response
			, error) in
			
			guard let data = data else { return }
			do {
				let decoder = JSONDecoder()
				let apiHomeData = try decoder.decode(Array<Podcast>.self, from: data)
				print(apiHomeData)
				DispatchQueue.main.async {
					self.dataStack.load2(podcasts: apiHomeData) { [weak self] success in
						self?.managedCollection.reloadData()
					}
				}
			} catch let err {
				print("Error, Couldnt load api data", err)
			}
			}.resume()
	}
}

// MARK: - UICollectionViewDataSource
extension PodcastCollectionDatasource: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let fakerepeats = 2
		return dataStack.allPods.count*fakerepeats
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let screenWidth = UIScreen.main.bounds.width
		let scaleFactor = (screenWidth / 3) - 6
		
		return CGSize(width: scaleFactor, height: scaleFactor)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as? PodcastCell else {
			assertionFailure("Should have dequeued PodcastCell here")
			return UICollectionViewCell()
		}
		return configured(cell, at: indexPath)
	}
	
	func configured(_ cell: PodcastCell, at indexPath: IndexPath) -> PodcastCell {
		let ipod = podcast(at: indexPath.row)
		cell.podcastTitle.text = ipod.title
		cell.artistName.text = ipod.artist
		ipod.loadPodcastImage { image in
			cell.coverArt.image = image
		}
		return cell
	}
	
	
}
