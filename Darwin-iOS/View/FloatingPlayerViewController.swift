//
//  FloatingPlayerViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

protocol FloatingPlayerDelegate: class {
	func expandPodcast(podcast: Podcast, episode: Episode)
}

class FloatingPlayerViewController: UIViewController, PodcastSubscriber, EpisodeSubscriber {
	// MARK: - Properties
	var currentPodcast: Podcast?
	var currentEpisode: Episode?
	weak var delegate: FloatingPlayerDelegate?
	
	// MARK: - IBOutlets
	@IBOutlet weak var thumbImage: UIImageView!
	@IBOutlet weak var episodeTitle: UILabel!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var ffButton: UIButton!
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

// MARK: - Internal
extension FloatingPlayerViewController {
	
	func configure(episode: Episode?, podcast: Podcast?) {
		if let podcast = podcast, let episode = episode {
			episodeTitle.text = episode.title
			podcast.loadPodcastImage { [weak self] (image) -> (Void) in
				self?.thumbImage.image = image
			}
		} else {
			episodeTitle.text = nil
			thumbImage.image = nil
		}
		currentEpisode = episode
		currentPodcast = podcast
	}
}

// MARK: - IBActions
extension FloatingPlayerViewController {
	
	@IBAction func tapGesture(_ sender: Any) {
		guard let podcast = currentPodcast else {
			return
		}
		guard let episode = currentEpisode else {
			return
		}
		delegate?.expandPodcast(podcast: podcast, episode: episode)
	}
}

extension FloatingPlayerViewController: ExpandingPlayerSourceProtocol {
	var originatingFrameInWindow: CGRect {
		let windowRect = view.convert(view.frame, to: nil)
		return windowRect
	}
	
	var originatingCoverImageView: UIImageView {
		return thumbImage
	}
}


