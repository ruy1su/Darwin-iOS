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
	
	@IBOutlet weak var subscribeCountButton: UIButton!
	
	@IBOutlet weak var height: NSLayoutConstraint!
	@IBOutlet weak var episodeListHeaderView: EpisodeListHeaderView!
	@IBOutlet weak var navBar: UINavigationBar!
	@IBOutlet weak var episodeTableView: UITableView!
	@IBAction func presentWebView(_ sender: Any) {
		self.performSegue(withIdentifier: "goto_webview", sender: self)
	}
	@IBAction func presentPodsForCat(_ sender: Any) {
		self.performSegue(withIdentifier: "cat_to_collection", sender: self)
	}
	@IBAction func presentSubscribeUser(_ sender: Any) {
		self.performSegue(withIdentifier: "sub_user_to_list", sender: self)
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
		getSubscribeCount()
		datasource = EpisodeTableViewDataSource(tableView: episodeTableView, podcast: currentPodcast!, player: hearThisPlayer!)
		datasource.load()
		datasource.registerSelectionObserver(observer: self)
		episodeListHeaderView.podcast = currentPodcast
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination =  segue.destination as? HearThisPlayerHolder {
			destination.hearThisPlayer = hearThisPlayer
		}
		if let destination =  segue.destination as? CategoryCollectionViewController {
			destination.currentCat = (currentPodcast?.category)!
			destination.API = APIKey.sharedInstance.getApi(key:"/api_pod_cat/\(currentPodcast?.category ?? "Arts")")
		}
		if let destination = segue.destination as? SubscribedUsersListViewController{
			destination.currentPodcast = currentPodcast
			destination.hearThisPlayer = hearThisPlayer
		}
		if let destination = segue.destination as? PodcastWebViewController{
			destination.urlString = (currentPodcast?.url)!
			destination.hearThisPlayer = hearThisPlayer
		}
	}
	
	func selected(_ episodeStack: EpisodeDataStack, on: IndexPath) {
		hearThisPlayer?.alwaysPause()
		if episodeStack.allEps.count == 0{
			alert(message: "", title: "Sorry We Cannot Load this Episode", action1: "Done", action2: "Go to the Website", podcast: currentPodcast!, controller: self)
		}
		else{
			episodeStack.setCoverArt(podcast: currentPodcast!, on: on)
		}
	}
	
	func getSubscribeCount() {
		Alamofire.request(APIKey.sharedInstance.getApi(key:"/api_coll_user_count/\(currentPodcast?.pid ?? 18)")).responseJSON { response in
			guard let dataDic = response.result.value else{
				return
			}
			let data = dataDic as! [NSDictionary]
			self.subscribeCountButton.setTitle(String(data.first!["count"] as! Int) + " Users Subscribed", for: .normal)
		}
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
			getSubscribeCount()
		}
		else{
			self.alert(message: "Please Log In First", title: "You Have Not Logged In", action: "Done")
		}
	}
	
}
