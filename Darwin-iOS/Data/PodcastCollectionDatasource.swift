//
//  PodcastCollectionDatasource.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

@objc
protocol PodcastSelectionObserver: class {
	func selected(_ podcast: DataStack, on: IndexPath)
}

@objc
protocol CollectionItemLoadCompleteDelegate:class  {
	func loadComplete()
}

class PodcastCollectionDatasource: NSObject {
	// Configure Loading Delegate
	var delegate: CollectionItemLoadCompleteDelegate?
	
	// Set up Data Stack
	var dataStack: DataStack
	var managedCollection: UICollectionView
	init(collectionView: UICollectionView) {
		
		dataStack = DataStack()
		managedCollection = collectionView
		super.init()
		managedCollection.dataSource = self
		managedCollection.delegate = self
	}
	private var loadingObservers = NSHashTable<CollectionItemLoadCompleteDelegate>.weakObjects()
	private var selectionObservers = NSHashTable<PodcastSelectionObserver>.weakObjects()
	func registerSelectionObserver(observer: PodcastSelectionObserver) {
		selectionObservers.add(observer)
	}
	func registerLoadingObserver(observer: CollectionItemLoadCompleteDelegate) {
		loadingObservers.add(observer)
	}
	func podcast(at index: Int) -> Podcast {
		let realindex = index % dataStack.allPods.count
		return dataStack.allPods[realindex]
	}
	
	func load(api: String) {
		let urlString = api.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
		let homeUrl = URL(string: urlString!)
		
		URLSession.shared.dataTask(with: homeUrl!) { (data, response
			, error) in
			guard let data = data else { return }
			do {
				let decoder = JSONDecoder()
				let apiHomeData = try decoder.decode(Array<Podcast>.self, from: data)
				print(apiHomeData[0],"\n ++++++ Fetched podcast data from backend ++++++\n")
				DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {
					self.dataStack.loadPod(podcasts: apiHomeData) { [weak self] success in
						self?.managedCollection.reloadData()
						for observer:CollectionItemLoadCompleteDelegate in (self?.loadingObservers.allObjects)! {
							observer.loadComplete()
						}
					}
				}
			} catch let err {
				print("Error, Couldnt load api data", err)
			}
			}.resume()
	}
}

// MARK: - UICollectionViewDataSource
extension PodcastCollectionDatasource: UICollectionViewDataSource,UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataStack.allPods.count
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
		cell.podcastTitle.text = String(utf8String:(ipod.title?.cString(using: String.Encoding.utf8))!)
		cell.artistName.text = ipod.artist
		
		// Load image from cache if cached
		let image = Cache.sharedInstance.update(imageURL: (ipod.coverArtURL)!)
		cell.coverArt.image = image
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		for observer:PodcastSelectionObserver in self.selectionObservers.allObjects {
			observer.selected(dataStack, on: indexPath)
		}
	}
}

