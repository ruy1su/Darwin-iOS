//
//  UserTableListDataSource.swift
//  Darwin-iOS
//
//  Created by Zenos on 9/2/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

@objc
protocol UserSelectionObserver: class {
	func selected(_ episode: UserDataStack, on: IndexPath)
}


class UserTableListDataSource: NSObject{
	
	var dataStack: UserDataStack
	var managedTable: UITableView
	var currentPodcast: Podcast
	init(tableView: UITableView, podcast: Podcast) {
		dataStack = UserDataStack()
		managedTable = tableView
		currentPodcast = podcast
		super.init()
		managedTable.dataSource = self
		managedTable.delegate = self
	}
	
	private var selectionObservers = NSHashTable<UserSelectionObserver>.weakObjects()
	
	func registerSelectionObserver(observer: UserSelectionObserver) {
		selectionObservers.add(observer)
	}
	
	func user(at index: Int) -> User {
		let realindex = index % dataStack.allUsers.count
		return dataStack.allUsers[realindex]
	}
	
	func load() {
		let pid = currentPodcast.pid
		guard let homeUrl = URL(string: APIKey.sharedInstance.getApi(key:"/api_coll_user/\(pid ?? 2)")) else { return }
		URLSession.shared.dataTask(with: homeUrl) { (data, response
			, error) in
			guard let data = data else { return }
			do {
				let decoder = JSONDecoder()
				let apiHomeData = try decoder.decode(Array<User>.self, from: data)
				print(apiHomeData)
				DispatchQueue.main.async {
					self.dataStack.load(users: apiHomeData) { [weak self] success in
						self?.managedTable.reloadData()
					}
				}
			} catch let err {
				print("Error, Couldnt load api data", err)
			}
			}.resume()
		
	}
}

extension UserTableListDataSource: UITableViewDataSource, UITableViewDelegate{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataStack.allUsers.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let user: User = dataStack.allUsers[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? SubscribeUserCell
		let rowUid = user.uid
		let currentUserUid = sharedDarwinUser.baseUid
		if rowUid == currentUserUid{
			cell?.followButton.setTitle("It's me!", for: .normal)
			cell?.followButton.isEnabled = false
		}
		else{
			Alamofire.request(APIKey.sharedInstance.getApi(key: "/user_followers/\(rowUid ?? 25)")).responseJSON { (response) in
				let data = response.result.value as! [NSDictionary]
				for i in data{
					if (i["fid"] as! Int) == currentUserUid{
						cell?.followButton.setTitle("Followed", for: .normal)
					}
				}
			}
		}
		cell?.user = user
		cell?.userImage.imageFromUrl(link: (user.imageURL)!)
		cell?.userName.text = user.fname! + " " + user.lname!
		return cell!
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		for observer:UserSelectionObserver in self.selectionObservers.allObjects {
			observer.selected(dataStack, on: indexPath)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
}

