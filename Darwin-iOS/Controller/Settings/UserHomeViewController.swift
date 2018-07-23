//
//  UserHomeViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/23/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class UserHomeViewController: UITableViewController, HearThisPlayerHolder, HearThisPlayerObserver {
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	
	@IBOutlet weak var loginButton: UIButton!
	@IBAction func loginTapped(_ sender: Any) {
		let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
		self.present(loginVC!, animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureLoginButton()
	}
	@IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
		
	}
}

extension UserHomeViewController{
	func configureLoginButton() {
		loginButton.layer.cornerRadius = 5
		loginButton.layer.borderWidth = 1
		loginButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.9).cgColor
	}
}
