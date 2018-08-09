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
			if self.deleteData(pid: pid!, title: title!){
				dataStack.allPods.remove(at: indexPath.row)
				self.CollectionPageTable.reloadData()
			}
			else{
				alert(message: "Failed to Delete Podcast:\(title!) From Your Collection. Please try again or check your internet.", title: "", action: "Will Do")
			}
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
		let firstTodoEndpoint:String = APIKey.sharedInstance.getApi(key: "/load_user_coll/\(sharedDarwinUser.baseUid)")
		Alamofire.request(firstTodoEndpoint).responseJSON { (response) in
			do{
				let apiHomeData = try JSONDecoder().decode(Array<Podcast>.self, from: (response.data)!)
				self.dataStack.loadPod(podcasts: apiHomeData) { success in
					self.CollectionPageTable.reloadData()}
			} catch {
				print("Unable to load data: \(error)")
			}
		}
	}
	
	// MARK: - Delete User Collection Data
	func deleteData(pid: Int, title: String) -> Bool {
		var success: Bool = true
		let firstTodoEndpoint: String = APIKey.sharedInstance.getApi(key: "/delete_usr_collection/\(sharedDarwinUser.baseUid)/\(pid)")
		Alamofire.request(firstTodoEndpoint, method: .delete)
			.responseString { response in
				if response.result.error == nil{
					self.alert(message: "Delete Podcast:\(title) From Your Collection Successfully!", title: "", action: "Cool")
					success = true
				}
				else{
					print("error calling DELETE on /delete_usr_collection/\(sharedDarwinUser.baseUid)/\(pid)")
					if let error = response.result.error {
						print("Error: \(error)")
					}
					success = false
				}
		}
		return success
	}
}
