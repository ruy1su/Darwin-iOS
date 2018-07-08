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


class DiscoverViewController: UIViewController, PodcastSubscriber {
	var currentPodcast: Podcast?

	// MARK: - Properties
	var datasource: PodcastCollectionDatasource!
	var floatingPlayer: FloatingPlayerViewController?
	var currentSong: Podcast?
	@IBOutlet weak var collectionView: UICollectionView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		datasource = PodcastCollectionDatasource(collectionView: collectionView)
		datasource.load()
		collectionView.delegate = self
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? FloatingPlayerViewController {
			floatingPlayer = destination
			floatingPlayer?.delegate = self as? FloatingPlayerDelegate
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	
}

// MARK: - UICollectionViewDelegate
extension DiscoverViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		currentPodcast = datasource.podcast(at: indexPath.row)
		floatingPlayer?.configure(podcast: currentPodcast)
	}
}
