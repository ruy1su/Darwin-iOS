//
//  FloatingPlayerViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

protocol FloatingPlayerDelegate: class {
	func expandEpisode(episode: Episode, playOrPause: Bool)
}

class FloatingPlayerViewController: UIViewController, TrackSubscriber, HearThisPlayerHolder{
	// MARK: - Properties
	var currentPodcast: Podcast?
	var currentEpisode: Episode?
	var playOrPause: Bool?
	weak var delegate: FloatingPlayerDelegate?
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	
	// MARK: - IBOutlets
	@IBOutlet weak var thumbImage: UIImageView!
	@IBOutlet weak var episodeTitle: UILabel!
	@IBOutlet weak var playButton: UIButton!{
		didSet{
			playButton.addTarget(self, action: #selector(FloatingPlayerViewController.playerButtonTapped(sender:)), for: .touchUpInside)
		}
	}
	@objc func playerButtonTapped(sender: Any) {
		hearThisPlayer?.pause()
	}
	@IBOutlet weak var ffButton: UIButton!
	@IBAction func nextTrack(_ sender: Any) {
		hearThisPlayer?.nextTrack()
	}
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
		playOrPause = false
	}
	
	func player(_ player: HearThisPlayerType, didStartPlaying track: Episode) {
		episodeTitle.text = track.title
		currentEpisode = track
		playButton.setImage(UIImage(named:"pause"), for: .normal)
		playOrPause = true
	}
	
	func player(_ player: HearThisPlayerType, didStopPlaying track: Episode) {
		playButton.setImage(UIImage(named:"play"), for: .normal)
		playOrPause = false
	}
	
	func player(_ player: HearThisPlayerType, didPausePlaying track: Episode) {
		episodeTitle.text = track.title
		currentEpisode = track
		playButton.setImage(UIImage(named:"play"), for: .normal)
		playOrPause = false
	}
	
	func player(_ player: HearThisPlayerType, willShutDown track: Episode) {
		alert(message: "", title: "Sorry We Cannot Load this Episode", action: "Done")
		playButton.setImage(UIImage(named:"play"), for: .normal)
		playOrPause = false
	}
}

// MARK: - IBActions
extension FloatingPlayerViewController {
	
	@IBAction func tapGesture(_ sender: Any) {
		guard let episode = currentEpisode else {
			return
		}
		delegate?.expandEpisode(episode: episode, playOrPause: playOrPause!)
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


