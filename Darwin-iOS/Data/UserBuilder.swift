//
//  UserBuilder.swift
//  Darwin-iOS
//
//  Created by Zenos on 9/2/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import Foundation

class UserBuilder: NSObject {
	
	// MARK: - Properties
	private var fname: String?
	private var lname: String?
	private var username: String?
	private var uid: Int?
	private var imageURL: String?
	
	func build() -> User? {
		guard let fname = fname,
			let lname = lname, let username = username else {
				return nil
		}
		return User(fname: fname, lname:lname, username: username, uid: uid, imageURL: imageURL)
	}
	
	func with(fname: String?) -> Self {
		self.fname = fname
		return self
	}
	
	func with(lname: String?) -> Self {
		self.lname = lname
		return self
	}
	
	func with(uid: Int?) -> Self {
		self.uid = uid
		return self
	}
	
	func with(username: String?) -> Self {
		if (username == nil){
			self.username = " "
		}
		else{
			self.username = username
		}
		return self
	}
	
	func with(imageURL: String?) -> Self {
		if (imageURL == nil){
			self.imageURL = " "
		}
		else{
			self.imageURL = imageURL
		}
		return self
	}
}
