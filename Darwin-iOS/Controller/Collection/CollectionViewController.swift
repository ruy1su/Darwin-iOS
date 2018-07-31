//
//  CollectionViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/29/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import Alamofire

class CollectionViewController: UIViewController, HearThisPlayerObserver,HearThisPlayerHolder,UITableViewDataSource, UITableViewDelegate{
	
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
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
	
	override func viewWillAppear(_ animated: Bool) {
		if sharedDarwinUser.loginStatus{
			CollectionPageTable.isHidden = false
			self.refreshData()
		}
		else{
			CollectionPageTable.isHidden = true
		}
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
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == UITableViewCellEditingStyle.delete) {
			let pid = dataStack.allPods[indexPath.row].pid
			let title = dataStack.allPods[indexPath.row].title
			dataStack.allPods.remove(at: indexPath.row)
			self.CollectionPageTable.reloadData()
			self.deleteData(pid: pid!, title: title!)
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "collection_tb_cell", for: indexPath) as? SearchResultTableCell
		
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

extension CollectionViewController{
	// MARK: - Refresh User Collection Data
	func refreshData(){
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
	
	// MARK: - Delete User Collection Data
	func deleteData(pid: Int, title: String){
		let firstTodoEndpoint: String = APIKey.sharedInstance.getApi(key: "/delete_usr_collection/\(sharedDarwinUser.baseUid)/\(pid)")
		Alamofire.request(firstTodoEndpoint, method: .delete)
			.responseString { response in
				guard response.result.error == nil else {
					// got an error in getting the data, need to handle it
					print("error calling DELETE on /delete_usr_collection/\(sharedDarwinUser.baseUid)/\(pid)")
					if let error = response.result.error {
						print("Error: \(error)")
					}
					return
				}
				let alert = UIAlertController(title: "Delete Podcast:\(title) From Your Collection Successfully!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
				alert.addAction(UIAlertAction(title: "Cool", style: UIAlertActionStyle.default, handler: nil))
				self.present(alert, animated: true, completion: nil)
				print("DELETE ok")
		}
	}
}
