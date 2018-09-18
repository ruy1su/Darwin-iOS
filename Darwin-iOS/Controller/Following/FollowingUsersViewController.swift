//
//  FollowingUsersViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 9/11/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import Alamofire

class FollowingUsersViewController: UIViewController, HearThisPlayerObserver,HearThisPlayerHolder,UITableViewDataSource, UITableViewDelegate{
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	var dataStack: UserDataStack!

	@IBOutlet weak var followingUserTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dataStack = UserDataStack()
		followingUserTableView.dataSource = self
		followingUserTableView.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		if sharedDarwinUser.loginStatus{
			followingUserTableView.isHidden = false
			self.refreshData()
		}
		else{
			followingUserTableView.isHidden = true
		}
		super.viewWillAppear(true)
	}
	
	func refreshData(){
		self.dataStack.allUsers.removeAll()
		let firstTodoEndpoint:String = APIKey.sharedInstance.getApi(key: "/load_user_following/\(sharedDarwinUser.baseUid)")
		Alamofire.request(firstTodoEndpoint).responseJSON { (response) in
			do{
				let apiHomeData = try JSONDecoder().decode(Array<User>.self, from: (response.data)!)
				if apiHomeData.count == 0{
					self.followingUserTableView.isHidden = true
				}
				else{
					self.dataStack.load(users: apiHomeData) { success in
						self.followingUserTableView.reloadData()
					}
				}
			} catch {
				print("Unable to load data: \(error)")
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataStack.allUsers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "user_tb_cell", for: indexPath) as? FollowingUserTableCell
		
		let item = dataStack.allUsers[indexPath.row]
		cell?.userName.text = item.fname! + " " + item.lname!
		cell?.userImage.imageFromUrl(link: (item.imageURL)!)
//		if let data =  NSData(contentsOf: NSURL(string: item.imageURL!)! as URL) {
//			if let image = UIImage(data: data as Data) {
//				cell?.userImage.image = image
//			}
//		}
		return cell!
	}
	


}
