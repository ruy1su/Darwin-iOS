//
//  DarwinUser.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/28/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

var sharedDarwinUser = DarwinUser(baseUid: 0, loginStatus: false)

class DarwinUser {
	
	// MARK: - Properties
	
	var baseUid: Int
	var loginStatus: Bool
	
	// Initialization
	
	init(baseUid: Int, loginStatus: Bool) {
		self.baseUid = baseUid
		self.loginStatus = false
	}
	
}
