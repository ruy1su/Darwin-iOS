//
//  NetworkingManager.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/23/18.
//  Copyright © 2018 Zixia. All rights reserved.
//


import Alamofire
import SwiftyJSON

enum ResponseStatus {
	case success
	case error(error: String)
}

class NetworkingManager: NSObject {
	
	class func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
		Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
			
			print(responseObject)
			
			if responseObject.result.isSuccess {
				let resJson = JSON(responseObject.result.value!)
				success(resJson)
			}
			if responseObject.result.isFailure {
				let error : Error = responseObject.result.error!
				failure(error)
			}
		}
	}
	
	class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
		
		Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
			
			print(responseObject)
			
			if responseObject.result.isSuccess {
				let resJson = JSON(responseObject.result.value!)
				success(resJson)
			}
			if responseObject.result.isFailure {
				let error : Error = responseObject.result.error!
				failure(error)
			}
		}
	}
}
