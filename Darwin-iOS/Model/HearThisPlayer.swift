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
	func play(_ track: Episode)
	func stop()
	func pause()
	func seekTo(_ timeInterval: TimeInterval)
	func currentTime() -> TimeInterval?
	func duration() -> TimeInterval?
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
}

extension HearThisPlayerObserver {
	func player(_ player: HearThisPlayerType, willStartPlaying track: Episode){}
	func player(_ player: HearThisPlayerType, didStartPlaying track: Episode) {}
	func player(_ player: HearThisPlayerType, didStopPlaying track: Episode)  {}
	func player(_ player: HearThisPlayerType, didPausePlaying track: Episode) {}
}

protocol HearThisPlayerHolder : class {
	var hearThisPlayer: HearThisPlayerType? {set get }
}

class HearThisPlayer: HearThisPlayerType {
	private var player = AVPlayer()
	var observers: NSHashTable<AnyObject>! = NSHashTable.weakObjects()
	
	fileprivate var currentEpisode: Episode?
	fileprivate var currentPodcast: Podcast?
	private let notificationCenter: NotificationCenter
	private let audioSession: AVAudioSession
	
	open var currentTime_: TimeInterval? {
		return CMTimeGetSeconds(self.player.currentTime())
	}
	
	open var duration_: TimeInterval? {
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

	func currentTime() -> TimeInterval? {
		return currentTime_
	}
	
	func duration() -> TimeInterval? {
		return duration_
	}
	
	func seekTo(_ timeInterval: TimeInterval) {
		self.player.seek(to: CMTime(seconds: timeInterval, preferredTimescale: 1000000))
	}
	
	func play(_ track: Episode) {
		self.resetPlayer()
		self.trackWillStartPlaying(track)
		DispatchQueue.global(qos: .background).async {
			[weak self] in
			guard let `self` = self else { return }
			let item = AVPlayerItem(url: URL(string: "http://www.archive.org/download/abirdingbronco_1103_librivox/abirdingonabronco_01_merriam_64kb.mp3")!)
			self.currentEpisode = track
			self.playItem(item)
		}
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
	
	@objc
	func playerDidFinishPlaying(note: NSNotification){
		if let track = currentEpisode {
			trackdDidStopPlaying(track: track)
		}
	}
	
}
