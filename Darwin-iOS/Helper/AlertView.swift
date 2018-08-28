//
//  AlertViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/31/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func alert(message: String, title: String = "", action: String = "OK") {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let OKAction = UIAlertAction(title: action, style: .default, handler: nil)
		alertController.addAction(OKAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func alert(message: String, title: String = "", action1: String = "OK", action2: String = "More", podcast: Podcast, controller: DiscoverViewController) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let OKAction = UIAlertAction(title: action1, style: .default, handler: nil)
		let MoreAction = UIAlertAction(title: action2, style: UIAlertActionStyle.cancel) {
			UIAlertAction in
			controller.performSegue(withIdentifier: "collection_to_table", sender: controller)
		}
		alertController.addAction(OKAction)
		alertController.addAction(MoreAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
}
