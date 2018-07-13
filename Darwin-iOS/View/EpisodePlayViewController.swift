//
//  EpisodePlayerViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/9/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class EpisodePlayViewController: UIViewController, PodcastSubscriber {
	
	// MARK: - IBOutlets
	@IBOutlet weak var episodeTitle: UILabel!
	@IBOutlet weak var episodeArtist: UILabel!
	@IBOutlet weak var episodeDuration: UILabel!
	// MARK: - Properties
	var currentPodcast: Podcast? {
		didSet {
			configureFields()
		}
	}
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configureFields()
	}
}

// MARK: - Internal
extension EpisodePlayViewController {
	
	func configureFields() {
		guard episodeTitle != nil else {
			return
		}
		
		episodeTitle.text = currentPodcast?.title
		episodeArtist.text = currentPodcast?.artist
		episodeDuration.text = "Duration \(currentPodcast?.presentationTime ?? "")"
	}
}

// MARK: - Podcast Extension
extension Podcast {

	var presentationTime: String {
//		let formatter = DateFormatter()
//		formatter.dateFormat = "mm:ss"
//		let date = Date(timeIntervalSince1970: duration)
//		return formatter.string(from: date)
		return "0"
	}
}
