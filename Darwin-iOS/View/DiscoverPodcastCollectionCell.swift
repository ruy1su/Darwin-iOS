//
//  PodcastCollectionCell.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/19/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class PodcastCell: UICollectionViewCell {
	
	// MARK: - IBOutlets
	@IBOutlet weak var coverArt: UIImageView!
	@IBOutlet weak var podcastTitle: UILabel!
	@IBOutlet weak var artistName: UILabel!
	
}

protocol SelectedCollectionItemDelegate {
	func selectedCollectionItem(podcast: DataStack, index: IndexPath)
}

class PodcsatCollectionCell: UITableViewCell, PodcastSelectionObserver{
	var delegate: SelectedCollectionItemDelegate?
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var datasource: PodcastCollectionDatasource!
	let homeAPI = "http://ec2-18-219-52-58.us-east-2.compute.amazonaws.com/api_home"

	override func awakeFromNib() {
		super.awakeFromNib()

		datasource = PodcastCollectionDatasource(collectionView: collectionView)
		datasource.load(api: homeAPI)
		datasource.registerSelectionObserver(observer: self)
		
	}
	func selected(_ podcast: DataStack, on: IndexPath) {
		self.delegate?.selectedCollectionItem(podcast: podcast, index: on)
	}
}
