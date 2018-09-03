//
//  SubscribedUsersListViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 9/2/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class SubscribedUsersListViewController: UIViewController, HearThisPlayerObserver,HearThisPlayerHolder, UserSelectionObserver {

	
	@IBOutlet weak var tableview: UITableView!
	var datasource: UserTableListDataSource!
	var currentPodcast: Podcast?
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		datasource = UserTableListDataSource(tableView: tableview, podcast: currentPodcast!)
		datasource.load()
		datasource.registerSelectionObserver(observer: self)
	}
	func selected(_ episode: UserDataStack, on: IndexPath) {
		
	}
	
}
