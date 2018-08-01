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
	
}
