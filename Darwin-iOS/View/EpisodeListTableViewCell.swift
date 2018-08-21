//
//  EpisodeListTableViewCell.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/13/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class EpisodeListTableViewCell: UITableViewCell, HearThisPlayerHolder, HearThisPlayerObserver {
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	var currentEpisode: Episode?
	var barsImageView: UIImageView?

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var artistLabel: UILabel!
	@IBOutlet weak var desLabel: UILabel!
	
	init(player: HearThisPlayerType, listItem: Episode) {
		self.currentEpisode = listItem
		self.hearThisPlayer = player
		super.init(style: .subtitle, reuseIdentifier: nil)
		
		self.updateView()

	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func player(_ player: HearThisPlayerType, didStartPlaying track: Episode) {
		if self.currentEpisode?.title == self.hearThisPlayer?.currentPlayItem()?.title {
			self.updateAccessoryView()
		}
		else{
			self.barsImageView?.stopAnimating()
			
		}
	}
	
	func player(_ player: HearThisPlayerType, willStartPlaying track: Episode) {
		if self.currentEpisode?.title == self.hearThisPlayer?.currentPlayItem()?.title {
			self.updateAccessoryView()
		}
		else{
			self.barsImageView?.stopAnimating()
		}
	}
	
	func player(_ player: HearThisPlayerType, didStopPlaying track: Episode) {
		if self.currentEpisode?.title == self.hearThisPlayer?.currentPlayItem()?.title {
			stopUpdateView()
		}
		else{
			self.barsImageView?.stopAnimating()
		}
	}
	func player(_ player: HearThisPlayerType, didPausePlaying track: Episode) {
		if self.currentEpisode?.title == self.hearThisPlayer?.currentPlayItem()?.title {
			stopUpdateView()
		}
		else{
			self.barsImageView?.stopAnimating()
		}
	}
	func player(_ player: HearThisPlayerType, willChangeTrack track: Episode) {
		self.barsImageView?.stopAnimating()
	}

	func stopUpdateView(){
		self.barsImageView?.removeFromSuperview()
		let imageView = UIImageView(frame: CGRect(x: self.contentView.bounds.maxX + 5, y: self.contentView.bounds.midY - 10, width: 20, height: 20))
		
		imageView.contentMode = .scaleAspectFit
		self.addSubview(imageView)
		imageView.image = UIImage(named: "bars1")
		self.barsImageView = imageView
	}
	
	func updateView(){
		self.imageView?.imageFromUrlWithChangedSize(url: (currentEpisode?.coverArtURL)!)
		self.imageView?.layer.cornerRadius = 5
		self.textLabel?.text = "\(self.currentEpisode?.title ?? "Artist") - \(self.currentEpisode?.artist ?? "Anonymous Artist")"
		self.detailTextLabel?.text = self.currentEpisode?.info
		self.detailTextLabel?.numberOfLines = 2
		self.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
		if self.currentEpisode?.title == self.hearThisPlayer?.currentPlayItem()?.title {
			self.updateAccessoryView()
		}
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		if self.currentEpisode?.title == self.hearThisPlayer?.currentPlayItem()?.title {
			self.updateAccessoryView()
		}
	}

	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)
		if self.currentEpisode?.title == self.hearThisPlayer?.currentPlayItem()?.title {
			self.updateAccessoryView()
		}
	}

	func updateAccessoryView(){
		self.accessoryView = nil
		self.barsImageView?.removeFromSuperview()

		let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
		self.accessoryView = containerView
		
		let imageView = UIImageView(frame: CGRect(x: self.contentView.bounds.maxX + 5, y: self.contentView.bounds.midY - 10, width: 20, height: 20))
		
		imageView.contentMode = .scaleAspectFit
		self.addSubview(imageView)
		
		if (self.hearThisPlayer?.isPlayingOrNot())! {
			var images = [UIImage]()
			for i in 1...9 {
				images.append(UIImage(named: "bars\(i)")!)
			}
			
			imageView.animationImages = images
			imageView.animationDuration = 1
			imageView.startAnimating()
		}
		else {
			imageView.image = UIImage(named: "bars1")
		}
		self.barsImageView = imageView
	}
	
}
