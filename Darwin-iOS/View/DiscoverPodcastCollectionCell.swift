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

class PodcsatCollectionCell: UITableViewCell, PodcastSelectionObserver, CollectionItemLoadCompleteDelegate{
	var delegate: SelectedCollectionItemDelegate?
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var datasource: PodcastCollectionDatasource!
	var API = APIKey.sharedInstance.getApi(key:"/api_home")
	var loadingView = UIView()
	var loadingLabel = UILabel()
	let spinner = UIActivityIndicatorView()
	override func awakeFromNib() {
		super.awakeFromNib()
		self.collectionView.backgroundColor = UIColor(rgb: 0xECEFF1)
		
		self.setLoadingScreen()
		datasource = PodcastCollectionDatasource(collectionView: collectionView)
		datasource.load(api: API)
		datasource.registerSelectionObserver(observer: self)
		datasource.registerLoadingObserver(observer: self)
	}
	
	func setLoadingScreen() {
		
		// Sets the view which contains the loading text and the spinner
		let width: CGFloat = 120
		let height: CGFloat = 30
		let x = (self.frame.width / 2)
		let y = (self.frame.height / 2) - height/2
		loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
		
		// Sets loading text
		loadingLabel.textColor = .gray
		loadingLabel.textAlignment = .center
		loadingLabel.text = "Loading..."
		loadingLabel.frame = CGRect(x: -45, y: 0, width: 100, height: 30)
		
		// Sets spinner
		spinner.activityIndicatorViewStyle = .whiteLarge
		spinner.frame = CGRect(x: -10, y: -30, width: 30, height: 30)
		spinner.startAnimating()
		
		// Adds text and spinner to the view
		loadingView.addSubview(spinner)
		loadingView.addSubview(loadingLabel)
		
		self.addSubview(loadingView)
		
	}
	private func removeLoadingScreen() {
		
		// Hides and stops the text and the spinner
		spinner.stopAnimating()
		spinner.isHidden = true
		loadingLabel.isHidden = true
		
	}
	func selected(_ podcast: DataStack, on: IndexPath) {
		self.delegate?.selectedCollectionItem(podcast: podcast, index: on)
	}
	
	func loadComplete() {
		self.removeLoadingScreen()
	}
	
}
