//
//  UserDataStack.swift
//  Darwin-iOS
//
//  Created by Zenos on 9/2/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import CoreData

class UserDataStack: NSObject {
	
	// MARK: - Properties
	var allUsers: [User] = []
	
	func load(users: [User], completion: (Bool) -> Void){
		for user in users {
			let builder = UserBuilder()
				.with(fname: user.fname)
				.with(lname: user.lname)
				.with(uid: user.uid)
				.with(imageURL: user.imageURL)
				.with(username: user.username)
			
			if let user = builder.build() {
				allUsers.append(user)
			}
			completion(true)
		}
	}
}
