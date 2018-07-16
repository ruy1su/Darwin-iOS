//
//  DarwinStartViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/14/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class DarwinStartViewController: UIViewController, HearThisPlayerHolder, TrackSubscriber {
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	
	var currentPodcast: Podcast?
	var currentEpisode: Episode?
	var floatingPlayer: FloatingPlayerViewController?

	override func viewDidLoad() {
		super.viewDidLoad()

		for childViewController in self.childViewControllers {
			if let playerHolder = childViewController as? HearThisPlayerHolder {
				playerHolder.hearThisPlayer = self.hearThisPlayer
			}
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? FloatingPlayerViewController {
			floatingPlayer = destination
			floatingPlayer?.delegate = self
		}
	}
}

extension DarwinStartViewController: HearThisPlayerObserver{
	func player(_ player: HearThisPlayerType, willStartPlaying track: Episode) {

		self.view.setNeedsUpdateConstraints()
	}
	
	func player(_ player: HearThisPlayerType, didStopPlaying track: Episode) {

		self.view.setNeedsUpdateConstraints()
	}
}

//  MARK: - FloatingPlayerDelegate
extension DarwinStartViewController: FloatingPlayerDelegate {

	func expandEpisode(episode: Episode) {
		guard let expandingPlayer = storyboard?.instantiateViewController(withIdentifier: "ExpandingPlayerViewController") as? ExpandingPlayerViewController else {
			assertionFailure("No view controller ID ExpandingPlayerViewController in storyboard")
			return
		}

		expandingPlayer.backingImage = view.makeSnapshot()
		expandingPlayer.currentEpisode = episode
		expandingPlayer.sourceView = floatingPlayer
		if let tabBar = tabBarController?.tabBar {
			expandingPlayer.tabBarImage = tabBar.makeSnapshot()
		}
		present(expandingPlayer, animated: false)
	}
}
