//
//  FloatingPlayerViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

protocol FloatingPlayerDelegate: class {
	func expandEpisode(episode: Episode)
}

class FloatingPlayerViewController: UIViewController, TrackSubscriber, HearThisPlayerHolder{
	// MARK: - Properties
	var currentPodcast: Podcast?
	var currentEpisode: Episode?
	weak var delegate: FloatingPlayerDelegate?
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	
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
extension FloatingPlayerViewController: HearThisPlayerObserver {
	func player(_ player: HearThisPlayerType, willStartPlaying track: Episode) {
		episodeTitle.text = track.title
		currentEpisode = track
		track.loadEpisodeImage { [weak self] (image) -> (Void) in
				self?.thumbImage.image = image
		}
	}
	
	func player(_ player: HearThisPlayerType, didStartPlaying track: Episode) {
		episodeTitle.text = track.title
		currentEpisode = track

	}
	
	func player(_ player: HearThisPlayerType, didStopPlaying track: Episode) {
	}
	
	// Function for Standby
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
		guard let episode = currentEpisode else {
			return
		}
		delegate?.expandEpisode(episode: episode)
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


