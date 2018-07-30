//
//  FacebookAPIManger.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/23/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

import FacebookCore
import FacebookLogin

let kGraphPathMe = "me"
let kGraphPathMePageLikes = "me/likes"

class FacebookAPIManager {
	
	let accessToken: AccessToken
	
	init(accessToken: AccessToken) {
		self.accessToken = accessToken
	}
	
	func requestFacebookUser(completion: @escaping (_ facebookUser: FacebookUser) -> Void) {
		let graphRequest = GraphRequest(graphPath: kGraphPathMe, parameters: ["fields":"id,email,last_name,first_name,picture"], accessToken: accessToken, httpMethod: .GET, apiVersion: .defaultVersion)
		graphRequest.start { (response: HTTPURLResponse?, result: GraphRequestResult<GraphRequest>) in
			switch result {
			case .success(let graphResponse):
				if let dictionary = graphResponse.dictionaryValue {
					completion(FacebookUser(dictionary: dictionary))
					print(dictionary)
				}
				break
			default:
				print("Facebook request user error")
			}
		}
	}
}
