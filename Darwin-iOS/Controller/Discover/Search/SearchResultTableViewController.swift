//
//  SearchResultTableViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/20/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

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
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return array.count
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
	@IBAction func prepareForUnwind(segue: UIStoryboardSegue) {

	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		currentPodcast = array[indexPath.row]
		performSegue(withIdentifier: "search_to_table", sender: self)
	}
}
