//
//  APIKey.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/29/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import Foundation

class APIKey: NSObject {
	static let sharedInstance = APIKey()
	
	private let API_URL = "http://ec2-18-219-52-58.us-east-2.compute.amazonaws.com"
	func getApi(key: String) -> String {
		return API_URL+key
	}
}
