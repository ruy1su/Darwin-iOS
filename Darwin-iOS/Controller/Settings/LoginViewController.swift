//
//  LoginViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/23/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBOutlet var usernameTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	
	@IBAction func backToHome(_ sender: Any) {
		self.performSegue(withIdentifier: "loginUnWind", sender: self)
	}
}
