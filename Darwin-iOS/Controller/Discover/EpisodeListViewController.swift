//
//  EpisodeListViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/12/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import Alamofire

class EpisodeListViewController: UIViewController, HearThisPlayerHolder, EpisodeSelectionObserver, HearThisPlayerObserver {

	var currentPodcast: Podcast?
	var datasource: EpisodeTableViewDataSource!
	var hearThisPlayer: HearThisPlayerType? {
		didSet {
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	var flag: Bool = true
	@IBOutlet weak var height: NSLayoutConstraint!
	@IBOutlet weak var episodeListHeaderView: EpisodeListHeaderView!
	@IBOutlet weak var navBar: UINavigationBar!
	@IBOutlet weak var episodeTableView: UITableView!
	
	@IBAction func dismiss(_ sender: Any) {
		self.performSegue(withIdentifier: "unWind", sender: self)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		if flag{
			self.navBar.removeFromSuperview()
			height.constant = 0
		}
		print(currentPodcast as Any,"\n ++++++ This is selected podcast ++++++ \n")
		datasource = EpisodeTableViewDataSource(tableView: episodeTableView, podcast: currentPodcast!)
		datasource.load()
		datasource.registerSelectionObserver(observer: self)
		episodeListHeaderView.podcast = currentPodcast
	}

	func selected(_ episodeStack: EpisodeDataStack, on: IndexPath) {
		hearThisPlayer?.stop()
		episodeStack.setCoverArt(podcast: currentPodcast!, on: on)
		hearThisPlayer?.play(episodeStack.allEps[on.row])
		print("Print Selected Image for info ======->", episodeStack.allEps[on.row].coverArtURL ?? "ok")
	}
}

extension EpisodeListViewController{
	@IBAction func AddIntoCollection(_ sender: Any) {
		if sharedDarwinUser.baseUid != 0{
			if let pid = currentPodcast?.pid {
				let parameters = ["uid": sharedDarwinUser.baseUid, "pid": pid]
				Alamofire.request(APIKey.sharedInstance.getApi(key:"/create_collection"), method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
					.responseString {
						response in switch response.result {
							
						case .success(let JSON):
							print("Success with JSON: \(JSON)")
							if JSON != "Success"{
								let alert = UIAlertController(title: "It's already in your collection", message: nil, preferredStyle: UIAlertControllerStyle.alert)
								alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
								self.present(alert, animated: true, completion: nil)
							}
							let alert = UIAlertController(title: "Add Into Collection Successfully", message: nil, preferredStyle: UIAlertControllerStyle.alert)
							alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
							self.present(alert, animated: true, completion: nil)
							
						case .failure(let error):
							print("Request failed with error: \(error)")
						}
				}
			}
		}
		else{
			let message = "Please Log In First"
			let alert = UIAlertController(title: "You Have Not Logged In", message: message, preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
}
