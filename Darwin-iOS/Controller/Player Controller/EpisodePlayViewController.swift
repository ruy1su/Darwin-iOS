//
//  EpisodePlayerViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/9/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class EpisodePlayViewController: UIViewController, TrackSubscriber, HearThisPlayerHolder, HearThisPlayerObserver {
	

	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	var currentPodcast: Podcast?
	var playOrPause: Bool?
	var timer: Timer?
	
	var currentEpisode: Episode?{
		didSet{
			configureFields()
		}
	}
	// MARK: - IBOutlets
	@IBOutlet weak var episodeTitle: UILabel!
	@IBOutlet weak var episodeArtist: UILabel!
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var previousTrackButton: UIButton!
	@IBOutlet weak var nextTrackButton: UIButton!
	@IBOutlet weak var playPauseButton: UIButton!
	@IBOutlet weak var elapsedTimeLabel: UILabel!
	@IBOutlet weak var remainingTimeLabel: UILabel!
	// MARK: - Properties


	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		configureFields()
		configureTimer()

	}
	
	@IBAction func pressPlayOrPause(_ sender: Any) {
		print("press playorpause button")
		hearThisPlayer?.pause()
	}
	
	@IBAction func swipeSlider(_ sender: Any) {
		hearThisPlayer?.seekTo(Double(self.slider.value))
	}
	@IBAction func previousTrack(_ sender: Any) {
		hearThisPlayer?.previousTrack()
	}
	@IBAction func nextTrack(_ sender: Any) {
		hearThisPlayer?.nextTrack()
	}
	
	func player(_ player: HearThisPlayerType, willStartPlaying track: Episode) {
		episodeTitle.text = track.title
		currentEpisode = track
	}
	
	func player(_ player: HearThisPlayerType, didStartPlaying track: Episode) {
		episodeTitle.text = track.title
		currentEpisode = track
		playPauseButton.setImage(UIImage(named:"pause"), for: .normal)
		
	}
	
	func player(_ player: HearThisPlayerType, didStopPlaying track: Episode) {
		self.dismiss(animated: false, completion: nil)
	}
	
	func player(_ player: HearThisPlayerType, didPausePlaying track: Episode) {
		episodeTitle.text = track.title
		currentEpisode = track
		playPauseButton.setImage(UIImage(named:"play"), for: .normal)
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
		if playOrPause!{
			playPauseButton.setImage(UIImage(named:"pause"), for: .normal)
		}
		else{
			playPauseButton.setImage(UIImage(named:"play"), for: .normal)
		}
		self.slider.minimumValue = 0
		self.slider.maximumValue = Float(self.hearThisPlayer?.duration() ?? 0)
	}
	func configureTimer() {
		timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(EpisodePlayViewController.track), userInfo: nil, repeats: true)
	}
	
	@objc func track()
	{
		if !self.slider.isTracking {
			self.slider.value = Float(self.hearThisPlayer?.currentTime() ?? 0)
		}
		
		self.updateTimeLabels()
	}
	
	func updateTimeLabels() {
		if let currentTime = self.hearThisPlayer?.currentTime(), let duration = self.hearThisPlayer?.duration() {
//			print(currentTime, duration)
			self.elapsedTimeLabel.text = self.humanReadableTimeInterval(currentTime)
			self.remainingTimeLabel.text = "-" + self.humanReadableTimeInterval(duration - currentTime)
		}
		else {
			self.elapsedTimeLabel.text = ""
			self.remainingTimeLabel.text = ""
		}
	}
	func humanReadableTimeInterval(_ timeInterval: TimeInterval) -> String {
		let timeInt = Int(round(timeInterval))
		let (hh, mm, ss) = (timeInt / 3600, (timeInt % 3600) / 60, (timeInt % 3600) % 60)
		
		let hhString: String? = hh > 0 ? String(hh) : nil
		let mmString = (hh > 0 && mm < 10 ? "0" : "") + String(mm)
		let ssString = (ss < 10 ? "0" : "") + String(ss)
		
		return (hhString != nil ? (hhString! + ":") : "") + mmString + ":" + ssString
	}
}
