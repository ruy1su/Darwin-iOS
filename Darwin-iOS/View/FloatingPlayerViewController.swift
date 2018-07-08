//
//  FloatingPlayerViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

protocol FloatingPlayerDelegate: class {
	func expandPodcast(podcast: Podcast)
}

class FloatingPlayerViewController: UIViewController, PodcastSubscriber {
	
	// MARK: - Properties
	var currentPodcast: Podcast?
	weak var delegate: FloatingPlayerDelegate?
	
	// MARK: - IBOutlets
	@IBOutlet weak var thumbImage: UIImageView!
	@IBOutlet weak var podcastTitle: UILabel!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var ffButton: UIButton!
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configure(podcast: nil)
	}
}

// MARK: - Internal
extension FloatingPlayerViewController {
	
	func configure(podcast: Podcast?) {
		if let podcast = podcast {
			podcastTitle.text = podcast.title
			podcast.loadPodcastImage { [weak self] (image) -> (Void) in
				self?.thumbImage.image = image
			}
		} else {
			podcastTitle.text = nil
			thumbImage.image = nil
		}
		currentPodcast = podcast
	}
}

// MARK: - IBActions
extension FloatingPlayerViewController {
	
	@IBAction func tapGesture(_ sender: Any) {
		guard let podcast = currentPodcast else {
			return
		}
		delegate?.expandPodcast(podcast: podcast)
	}
}


