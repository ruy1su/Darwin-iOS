//
//  User.swift
//  Darwin-iOS
//
//  Created by Zenos on 9/2/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

struct User:Codable {
	
	// MARK: - Properties
	let fname: String?
	let lname: String?
	let username: String?
	let uid: Int?
	let imageURL: String?
	private enum CodingKeys: String, CodingKey {
		case fname
		case lname
		case username
		case uid
		case imageURL = "imageURL"
	}
}
