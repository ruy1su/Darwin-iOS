//
//  HearThisPlayer.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/16/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import Foundation
import AVFoundation

protocol HearThisPlayerType {
	func playItems(_ playbackItems: [Episode], firstItem: Episode?)
	func play(_ track: Episode)
	func stop()
	func pause()
	func alwaysPause()
	func currentPlayItem()  -> Episode?
	func previousTrack()
	func nextTrack()
	func seekTo(_ timeInterval: TimeInterval)
	func currentTime() -> TimeInterval?
	func duration() -> TimeInterval?
	func isPlayingOrNot() -> Bool?
	mutating func registerObserver(observer: HearThisPlayerObserver)
	var observers: NSHashTable<AnyObject>! { set get }
}
extension HearThisPlayerType {
	mutating func registerObserver(observer: HearThisPlayerObserver) {
		self.observers.add(observer)
	}
}

protocol HearThisPlayerObserver: class {
	func player(_ player: HearThisPlayerType, willStartPlaying track: Episode)
	func player(_ player: HearThisPlayerType, didStartPlaying track: Episode)
	func player(_ player: HearThisPlayerType, didStopPlaying track: Episode)
	func player(_ player: HearThisPlayerType, didPausePlaying track: Episode)
	func player(_ player: HearThisPlayerType, willShutDown track: Episode)
	func player(_ player: HearThisPlayerType, willChangeTrack track: Episode)
}

extension HearThisPlayerObserver {
	func player(_ player: HearThisPlayerType, willStartPlaying track: Episode){}
	func player(_ player: HearThisPlayerType, didStartPlaying track: Episode) {}
	func player(_ player: HearThisPlayerType, didStopPlaying track: Episode)  {}
	func player(_ player: HearThisPlayerType, didPausePlaying track: Episode) {}
	func player(_ player: HearThisPlayerType, willShutDown track: Episode) {}
	func player(_ player: HearThisPlayerType, willChangeTrack track: Episode) {}
}

protocol HearThisPlayerHolder : class {
	var hearThisPlayer: HearThisPlayerType? {set get }
}

//extension Episode: Equatable {}

class HearThisPlayer: HearThisPlayerType {


	private var player = AVPlayer()
	private let notificationCenter: NotificationCenter
	private let audioSession: AVAudioSession
	var observers: NSHashTable<AnyObject>! = NSHashTable.weakObjects()
	
	open var currentEpisode: Episode?
	open var currentPodcast: Podcast?
	open var playbackItems: [Episode]?
	open var nextPlaybackItem: Episode? {
		guard let playbackItems = self.playbackItems, let currentPlaybackItem = self.currentEpisode else { return nil }
		
		let nextItemIndex = playbackItems.index(of: currentPlaybackItem)! + 1
		if nextItemIndex >= playbackItems.count { return nil }
		
		return playbackItems[nextItemIndex]
	}
	open var previousPlaybackItem: Episode? {
		guard let playbackItems = self.playbackItems, let currentPlaybackItem = self.currentEpisode else { return nil }
		
		let previousItemIndex = playbackItems.index(of: currentPlaybackItem)! - 1
		if previousItemIndex < 0 { return nil }
		
		return playbackItems[previousItemIndex]
	}
	open var currentTime_: TimeInterval? {
		return CMTimeGetSeconds(self.player.currentTime())
	}
	
	open var duration_: TimeInterval? {
		let minute:TimeInterval = 60.0
		if self.player.currentItem == nil{
			return minute
		}
		return CMTimeGetSeconds((self.player.currentItem?.asset.duration)!)
	}
	
	open var isPlaying: Bool {
		if (player.rate != 0) && (player.error == nil) {
			return true
		}
		else{
			return false
		}
	}
	
	func isPlayingOrNot() -> Bool? {
		return isPlaying
	}
	
	init(notificationCenter: NotificationCenter = NotificationCenter.default, audioSession:AVAudioSession = AVAudioSession.sharedInstance()) {
		self.notificationCenter = notificationCenter
		self.audioSession = audioSession
		
		player.addBoundaryTimeObserver(forTimes: [CMTime(seconds: 0.001, preferredTimescale: 1000) as NSValue], queue: nil, using:{
			if let currentEpisode = self.currentEpisode {
				self.trackdDidStartPlaying(track: currentEpisode)
			}
		})
		notificationCenter.addObserver(self, selector: #selector(HearThisPlayer.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
	}

	func currentPlayItem() -> Episode?{
		return currentEpisode
	}
	
	func currentTime() -> TimeInterval? {
		return currentTime_
	}
	
	func duration() -> TimeInterval? {
		return duration_
	}
	
	func seekTo(_ timeInterval: TimeInterval) {
		self.player.seek(to: CMTime(seconds: timeInterval, preferredTimescale: 1000000))
	}
	
	open func nextTrack() {
		guard let nextPlaybackItem = self.nextPlaybackItem else { return }
		self.willChangeTrack(track: nextPlaybackItem)
		self.play(nextPlaybackItem)
	}
	
	open func previousTrack() {
		guard let previousPlaybackItem = self.previousPlaybackItem else { return }
		self.willChangeTrack(track: nextPlaybackItem!)
		self.play(previousPlaybackItem)
	}
	
	open func playItems(_ playbackItems: [Episode], firstItem: Episode? = nil) {
		self.playbackItems = playbackItems
		
		if playbackItems.count == 0 {
			self.stop()
			return
		}
		
		let playbackItem = firstItem ?? self.playbackItems!.first!
		self.currentEpisode = playbackItem
		self.play(playbackItem)
	}
	
	func play(_ track: Episode) {
		if ((track.mediaURL?.absoluteString) == "http://"){
			self.willShutDown(track: track)
		}
		else{
			self.stop()
			self.resetPlayer()
			self.trackWillStartPlaying(track)
			DispatchQueue.global(qos: .background).async {
				[weak self] in
				guard let `self` = self else { return }
				print(track.mediaURL!,"...........")
				let item = AVPlayerItem(url: track.mediaURL!)
				self.currentEpisode = track
				self.playItem(item)
			}
		}
	}
	
	func alwaysPause(){
		player.pause()
	}
	
	func pause(){
		if isPlaying {
			player.pause()
			if let currentTrack = self.currentEpisode {
				self.trackdDidPausePlaying(track: currentTrack)
			}
		}
		else {
			player.play()
			if let currentTrack = self.currentEpisode {
				self.trackdDidStartPlaying(track: currentTrack)
			}
		}
	}
	
	func stop() {
		player.pause()
		self.resetPlayer()
		if player.currentItem != nil {
			player.replaceCurrentItem(with: nil)
			if let currentTrack = self.currentEpisode {
				self.trackdDidStopPlaying(track: currentTrack)
			}
			self.currentEpisode = nil
		}
	}
	
	private
	func playItem(_ item: AVPlayerItem) {
		player.replaceCurrentItem(with: item)
		player.play()
		do {
			try audioSession.setCategory(AVAudioSessionCategoryPlayback)
			do {
				try audioSession.setActive(true)
			} catch let error as NSError {
				print(error.localizedDescription)
			}
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	private
	func resetPlayer(){
		if let currentItem = self.player.currentItem {
			currentItem.cancelPendingSeeks()
			currentItem.asset.cancelLoading()
		}
	}
}

extension HearThisPlayer {
	
	fileprivate
	func trackWillStartPlaying(_ track:Episode) {
		DispatchQueue.main.async {
			[weak self] in
			guard let `self` = self else { return }
			
			for observer in self.observers.allObjects {
				if let observer = observer as? HearThisPlayerObserver {
					observer.player(self, willStartPlaying: track)
				}
			}
			print(track.title ?? "ok","???????????????")
		}
	}
	
	fileprivate
	func trackdDidStartPlaying(track: Episode) {
		DispatchQueue.main.async {
			[weak self] in
			guard let `self` = self else { return }
			
			for observer in self.observers.allObjects {
				if let observer = observer as? HearThisPlayerObserver {
					observer.player(self, didStartPlaying: track)
				}
			}
		}
	}
	
	fileprivate
	func trackdDidPausePlaying(track: Episode) {
		DispatchQueue.main.async {
			[weak self] in
			guard let `self` = self else { return }
			
			for observer in self.observers.allObjects {
				if let observer = observer as? HearThisPlayerObserver {
					observer.player(self, didPausePlaying: track)
				}
			}
		}
	}
	
	fileprivate
	func trackdDidStopPlaying(track: Episode) {
		DispatchQueue.main.async {
			[weak self] in
			guard let `self` = self else { return }
			
			for observer in self.observers.allObjects {
				if let observer = observer as? HearThisPlayerObserver {
					observer.player(self, didStopPlaying: track)
				}
			}
		}
	}
	
	fileprivate
	func willShutDown(track: Episode) {
		DispatchQueue.main.async {
			[weak self] in
			guard let `self` = self else { return }
			
			for observer in self.observers.allObjects {
				if let observer = observer as? HearThisPlayerObserver {
					observer.player(self, willShutDown: track)
				}
			}
		}
	}
	fileprivate
	func willChangeTrack(track: Episode) {
		DispatchQueue.main.async {
			[weak self] in
			guard let `self` = self else { return }
			
			for observer in self.observers.allObjects {
				if let observer = observer as? HearThisPlayerObserver {
					observer.player(self, willChangeTrack: track)
				}
			}
		}
	}
	
	@objc
	func playerDidFinishPlaying(note: NSNotification){
		if let track = currentEpisode {
			trackdDidStopPlaying(track: track)
		}
	}
	
}
