//
//  EpisodePlayerViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/9/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class EpisodePlayViewController: UIViewController, EpisodeSubscriber {
	// MARK: - IBOutlets
	@IBOutlet weak var episodeTitle: UILabel!
	@IBOutlet weak var episodeArtist: UILabel!
	@IBOutlet weak var episodeDuration: UILabel!
	// MARK: - Properties

	var currentEpisode: Episode?{
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
		
		episodeTitle.text = currentEpisode?.title
		episodeArtist.text = currentEpisode?.artist
		episodeDuration.text = "Duration \(currentEpisode?.presentationTime ?? "")"
	}
}

// MARK: - Podcast Extension
extension Episode {

	var presentationTime: String {
//		let formatter = DateFormatter()
//		formatter.dateFormat = "mm:ss"
//		let date = Date(timeIntervalSince1970: duration)
//		return formatter.string(from: date)
		return "0"
	}
}
