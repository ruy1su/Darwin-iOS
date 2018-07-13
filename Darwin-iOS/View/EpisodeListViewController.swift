//
//  EpisodeListViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/12/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class EpisodeListViewController: UIViewController, PodcastSubscriber {
	var currentPodcast: Podcast?
	override func viewDidLoad() {
		super.viewDidLoad()
		print(currentPodcast as Any)
		print("what")
	}
}
