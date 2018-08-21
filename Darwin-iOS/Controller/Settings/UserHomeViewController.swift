//
//  UserHomeViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/23/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class UserHomeViewController: UITableViewController, HearThisPlayerHolder, HearThisPlayerObserver {
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	
	@IBOutlet weak var loginButton: UIButton!
	
	@IBOutlet weak var userImage: UIImageView!
	
	@IBOutlet weak var userName: UILabel!
	
	@IBAction func loginTapped(_ sender: Any) {
		if sharedDarwinUser.loginStatus {
			LoginManager().logOut()
			sharedDarwinUser.loginStatus = false
			loginButton.setTitle("Log In", for: .normal)
			userImage.image = UIImage(named: "user")
			userName.text = nil
		}
		else{
			let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
			self.present(loginVC!, animated: true, completion: nil)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureLoginButton()
	}
	
	// MARK - Handle Unwind Event without Login
	@IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
		print("Unwind without Login")
	}
	
	// MARK - Handle Unwind Event for FB Login
	@IBAction func unwindToThisView(sender: UIStoryboardSegue) {
		if let sourceViewController = sender.source as? LoginViewController {
			userName.text = sourceViewController.userName
			if sourceViewController.userImageURL != nil{
				userImage.imageFromUrl(link: (sourceViewController.userImageURL)!)
			}
			loginButton.setTitle("Log Out", for: .normal)
		}
	}
}
extension UserHomeViewController{
	func configureLoginButton() {
		loginButton.layer.cornerRadius = 5
		loginButton.layer.borderWidth = 1
		loginButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.9).cgColor
	}
}
