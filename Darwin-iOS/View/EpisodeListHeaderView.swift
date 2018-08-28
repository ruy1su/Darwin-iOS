//
//  EpisodeListHeaderView.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/16/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class EpisodeListHeaderView: UIView {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var avatarView: UIImageView!
	@IBOutlet weak var category: UIButton!
	
	var podcast: Podcast? {
		didSet{
			titleLabel.text = podcast?.title
			category.layer.cornerRadius = 5
			category.setTitle(podcast?.category, for: .normal)
			if let podcast = self.podcast {
				avatarView.imageFromUrl(link: (podcast.coverArtURL?.absoluteString)!)
				avatarView.clipsToBounds = true
				avatarView.layer.cornerRadius = avatarView.frame.size.width / 2.0
			}
		}
	}
	
}
