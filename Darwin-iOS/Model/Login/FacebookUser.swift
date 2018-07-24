//
//  FacebookUser.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/23/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import Foundation

class FacebookUser {
	let firstName: String?
	let lastName: String?
	let email: String?
	let id: String?
	let profilePicture: String?
	
	init (dictionary: [String: Any]) {
		self.firstName = dictionary["first_name"] as? String
		self.lastName = dictionary["last_name"] as? String
		self.email = dictionary["email"] as? String
		self.id = dictionary["id"] as? String
		if let pictureDict = dictionary["picture"] as? [String: Any] {
			if let dataDict = pictureDict["data"] as? [String: Any] {
				self.profilePicture = dataDict["url"] as? String
				return
			}
		}
		self.profilePicture = ""
	}
	
	init (firstName: String?, lastName: String?, email: String?, id: String?, profilePicture: String?) {
		self.firstName = firstName
		self.lastName = lastName
		self.email = email
		self.id = id
		self.profilePicture = profilePicture
	}
}
