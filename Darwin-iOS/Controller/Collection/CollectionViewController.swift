//
//  CollectionViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/29/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, HearThisPlayerObserver,HearThisPlayerHolder,UITableViewDataSource, UITableViewDelegate{
	
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
			print(hearThisPlayer)
		}
	}
	
	@IBOutlet weak var CollectionPageTable: UITableView!
	
	var dataStack: DataStack!
	var currentPodcast: Podcast?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dataStack = DataStack()
		CollectionPageTable.dataSource = self
		CollectionPageTable.delegate = self
	}
	
	@IBAction func refresh(_ sender: Any) {
		if sharedDarwinUser.baseUid != 0{
			guard let Url = URL(string: APIKey.sharedInstance.getApi(key: "/load_user_coll/\(sharedDarwinUser.baseUid)")) else { return }
			URLSession.shared.dataTask(with: Url) { (data, response
				, error) in
				guard let data = data else { return }
				do {
					let decoder = JSONDecoder()
					let apiHomeData = try decoder.decode(Array<Podcast>.self, from: data)
					DispatchQueue.main.async {
						self.dataStack.loadPod(podcasts: apiHomeData) { success in
							self.CollectionPageTable.reloadData()
						}
					}
				} catch let err {
					print("Error, Couldnt load api data", err)
				}
				}.resume()
		}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination =  segue.destination as? EpisodeListViewController {
			destination.currentPodcast = currentPodcast
		}
		if let destination = segue.destination as? HearThisPlayerHolder{
			destination.hearThisPlayer = hearThisPlayer
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
	}
	
	// MARK: - Table view data source
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return dataStack.allPods.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchResultTableCell
		
		let item = dataStack.allPods[indexPath.row]
		cell?.titleLabel.text = item.title
		if let data =  NSData(contentsOf: item.coverArtURL!){
			if let image = UIImage(data: data as Data) {
				cell?.coverArt.image = image
			}
		}
		return cell!
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		currentPodcast = dataStack.allPods[indexPath.row]
		performSegue(withIdentifier: "collection_to_eps", sender: self)
	}
}
