//
//  DarwinUser.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/28/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

var sharedDarwinUser = DarwinUser(baseUid: 0)

class DarwinUser {
	
	// MARK: - Properties
	
	var baseUid: Int
	
	// Initialization
	
	init(baseUid: Int) {
		self.baseUid = baseUid
	}
	
}
