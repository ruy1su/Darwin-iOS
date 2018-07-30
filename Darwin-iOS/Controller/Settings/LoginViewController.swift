//
//  LoginViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/23/18.
//  Copyright © 2018 Zixia. All rights reserved.
//
import FacebookCore
import UIKit
import FacebookLogin
import Alamofire

class LoginViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// Variables for passing to user home page (An ugly way)
	var userName: String?
	var userImageURL: String?
	
	@IBOutlet var usernameTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	
	@IBAction func backToHome(_ sender: Any) {
		self.performSegue(withIdentifier: "loginUnWind", sender: self)
	}
	
	private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]
	
	@IBAction func didTapLoginButton(_ sender: LoginButton) {
		// Regular login attempt. Add the code to handle the login by email and password.
		guard let email = usernameTextField.text, let pass = passwordTextField.text else {
			// It should never get here
			return
		}
		didLogin(method: "email and password", info: "Email: \(email) \n Password: \(pass)")
	}
	
	@IBAction func didTapFacebookLoginButton(_ sender: FacebookLoginButton) {
		// Facebook login attempt
		let loginManager = LoginManager()
		loginManager.logIn(readPermissions: readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
	}
	
	@IBAction func didTapTwitterLoginButton(_ sender: TwitterLoginButton) {
		// Twitter login attempt
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		usernameTextField.resignFirstResponder()
		passwordTextField.resignFirstResponder()
	}
	
	private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
		switch loginResult {
		case .success:
			didLoginWithFacebook()
		case .failed(_): break
		default: break
		}
	}
	
	private func didLoginWithFacebook() {
		// Successful log in with Facebook
		if let accessToken = AccessToken.current {
			let facebookAPIManager = FacebookAPIManager(accessToken: accessToken)
			facebookAPIManager.requestFacebookUser(completion: { (facebookUser) in
				if let _ = facebookUser.email {
					let info = "First name: \(facebookUser.firstName!) \n Last name: \(facebookUser.lastName!) \n Email: \(facebookUser.email!)"
					self.didLogin(method: "Facebook", info: info)
					self.userName = facebookUser.firstName!+" "+facebookUser.lastName!
					self.userImageURL = facebookUser.profilePicture
					let parameters = ["fname": facebookUser.firstName!, "lname": facebookUser.lastName!, "email": facebookUser.email!]
					Alamofire.request(APIKey.sharedInstance.getApi(key:"/create_user"), method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
						.responseJSON {
							response in switch response.result {
							
							case .success(let JSON):
								print("Success with JSON: \(JSON)")
								Alamofire.request(APIKey.sharedInstance.getApi(key:"/login/\(facebookUser.email!)"), method : .get).responseJSON { response in
									let data = response.result.value as! NSDictionary
									print(data["uid"]!)
									sharedDarwinUser.baseUid = data["uid"] as! Int
								}
								
							case .failure(let error):
								print("Request failed with error: \(error)")
								
							}
					}
				}
			})
		}
	}
	
	private func didLogin(method: String, info: String) {
		let message = "Successfully logged in with \(method). " + info
		let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { action in
			switch action.style{
			case .default:
				self.performSegue(withIdentifier: "loginFBUnWind", sender: self)
			case .cancel: break
			case .destructive: break
			}
		  }))
		self.present(alert, animated: true, completion: nil)
	}
	
}
