//
//  SettingViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 8/9/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
	@IBOutlet weak var removeCache: UITableViewCell!
	
	@IBOutlet weak var cacheSize: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		cacheSize.text = String(Float(URLCache.shared.currentDiskUsage) / Float(1000000)) + " MB"
	}

	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0{
			URLCache.shared.removeAllCachedResponses()
			cacheSize.text = String(Int(Float(URLCache.shared.currentDiskUsage) / Float(1000000) - 0.156376)) + " MB"
			alert(message: "Removed Cache Successflly", title: "Clear Cache", action: "Done")
		}
	}
}
