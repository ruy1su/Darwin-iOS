//
//  PodcastCollectionCell.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/19/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

protocol SelectedCollectionItemDelegate {
	func selectedCollectionItem(podcast: DataStack, index: IndexPath)
}

class PodcsatCollectionCell: UITableViewCell, TrackSubscriber, HearThisPlayerHolder, HearThisPlayerObserver, PodcastSelectionObserver{
	var delegate: SelectedCollectionItemDelegate?
	
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	var currentPodcast: Podcast?
	var currentEpisode: Episode?
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var datasource: PodcastCollectionDatasource!
	let homeAPI = "http://ec2-18-219-52-58.us-east-2.compute.amazonaws.com/api_home"

	override func awakeFromNib() {
		super.awakeFromNib()

		datasource = PodcastCollectionDatasource(collectionView: collectionView)
		datasource.load(api: homeAPI)
		datasource.registerSelectionObserver(observer: self)
		print("hello")
		
	}
	func selected(_ podcast: DataStack, on: IndexPath) {
		self.delegate?.selectedCollectionItem(podcast: podcast, index: on)
	}
}
