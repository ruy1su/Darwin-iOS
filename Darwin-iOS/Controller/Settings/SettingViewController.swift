//
//  SettingViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 8/9/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	@IBOutlet weak var removeCache: UITableViewCell!
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0{
			alert(message: "Removed Cache Successflly", title: "Clear Cache", action: "Done")
		}
	}
}
