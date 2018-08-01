//
//  SearchResultTableViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/20/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import Alamofire

class SearchResultTableViewController: UITableViewController, HearThisPlayerObserver{
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	
	var array = [Podcast]()
	var isLoading = false
	var arrayFilter = [String]()
	var currentPodcast: Podcast?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let transition = CATransition()
		transition.duration = 0.3
		transition.type = kCATransitionPush
		transition.subtype = kCATransitionFromRight
		view.window!.layer.add(transition, forKey: kCATransition)
		if let destination =  segue.destination as? EpisodeListViewController {
			destination.currentPodcast = currentPodcast
			destination.flag = false
		}
		if let destination = segue.destination as? HearThisPlayerHolder{
			destination.hearThisPlayer = hearThisPlayer
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	@IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
		
	}
	
	// MARK: - Table view data source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return array.count
	}
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
		let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
			self.currentPodcast = self.array[editActionsForRowAt.row]
			self.performSegue(withIdentifier: "search_to_table", sender: self)
			print("more button tapped")
		}
		more.backgroundColor = .lightGray
		
		let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
			print("favorite button tapped")
			let pid = self.array[editActionsForRowAt.row].pid
			let title = self.array[editActionsForRowAt.row].title
			self.addDataIntoCollection(pid: pid!, title: title!)
		}
		favorite.backgroundColor = .orange
		
		let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
			print("share button tapped")
		}
		share.backgroundColor = .blue
		
		return [share, favorite, more]
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchResultTableCell
		let item = array[indexPath.row]
		cell?.titleLabel.text = item.title
		if let data =  NSData(contentsOf: item.coverArtURL!){
			if let image = UIImage(data: data as Data) {
				cell?.coverArt.image = image
			}
		}
		return cell!
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		currentPodcast = array[indexPath.row]
		performSegue(withIdentifier: "search_to_table", sender: self)
	}
}

extension SearchResultTableViewController{
	// MARK: - Delete User Collection Data
	func addDataIntoCollection(pid: Int, title: String){
		if sharedDarwinUser.loginStatus{
			if let pid = currentPodcast?.pid {
				let parameters = ["uid": sharedDarwinUser.baseUid, "pid": pid]
				Alamofire.request(APIKey.sharedInstance.getApi(key:"/create_collection"), method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
					.responseString {
						response in switch response.result {
						case .success(let JSON):
							print("Success with JSON: \(JSON)")
							if JSON != "Success"{
								self.alert(message: "It's already in your collection", title: "", action: "Done")
							}else{
								self.alert(message: "Add Into Collection Successfully", title: "", action: "Done")
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
