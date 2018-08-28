//
//  EpisodeListViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/12/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import Alamofire

class EpisodeListViewController: UIViewController, HearThisPlayerHolder, EpisodeSelectionObserver, HearThisPlayerObserver{
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
	@IBAction func presentPodsForCat(_ sender: Any) {
		self.performSegue(withIdentifier: "cat_to_collection", sender: self)
	}
	
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
		datasource = EpisodeTableViewDataSource(tableView: episodeTableView, podcast: currentPodcast!, player: hearThisPlayer!)
		datasource.load()
		datasource.registerSelectionObserver(observer: self)
		episodeListHeaderView.podcast = currentPodcast
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destiantion =  segue.destination as? HearThisPlayerHolder {
			destiantion.hearThisPlayer = hearThisPlayer
		}
		if let destiantion =  segue.destination as? CategoryCollectionViewController {
			destiantion.currentCat = (currentPodcast?.category)!
			destiantion.API = APIKey.sharedInstance.getApi(key:"/api_pod_cat/\(currentPodcast?.category ?? "Arts")")
		}
	}
	
	func selected(_ episodeStack: EpisodeDataStack, on: IndexPath) {
		hearThisPlayer?.alwaysPause()
		if episodeStack.allEps.count == 0{
			alert(message: "", title: "Sorry We Cannot Load this Episode", action: "Done")
		}
		else{
			episodeStack.setCoverArt(podcast: currentPodcast!, on: on)
//			hearThisPlayer?.playItems(episodeStack.allEps, firstItem: episodeStack.allEps[on.row])
		}
		print("Print Selected Image for info ======->", episodeStack.allEps[on.row].coverArtURL ?? "ok")
	}
}

extension EpisodeListViewController{
	@IBAction func AddIntoCollection(_ sender: Any) {
		if sharedDarwinUser.loginStatus{
			if let pid = currentPodcast?.pid {
				let parameters = ["uid": sharedDarwinUser.baseUid, "pid": pid]
				Alamofire.request(APIKey.sharedInstance.getApi(key:"/create_collection"), method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
					.responseString {
						response in switch response.result {
							
						case .success(let JSON):
							print("Success with JSON: \(JSON)")
							if JSON != "Success"{
								self.alert(message: "", title: "It's already in your collection", action: "Done")
							}
							else{
								self.alert(message: "", title: "Add Into Collection Successfully", action: "Done")
							}
						case .failure(let error):
							print("Request failed with error: \(error)")
						}
				}
			}
		}
		else{
			self.alert(message: "Please Log In First", title: "You Have Not Logged In", action: "Done")
		}
	}
}
