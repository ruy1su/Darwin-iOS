//
//  SubscribeUserCell.swift
//  Darwin-iOS
//
//  Created by Zenos on 9/2/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import Alamofire

class SubscribeUserCell: UITableViewCell {
	
	var user: User!
	@IBOutlet weak var userImage: UIImageView!
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var followButton: UIButton!
	
	@IBAction func Follow(_ sender: Any) {
		if sharedDarwinUser.loginStatus{
			if followButton.titleLabel?.text == "Follow"{ // Follow this one
				if sharedDarwinUser.baseUid != user.uid{
					let parameters = ["uid": user.uid, "fid": sharedDarwinUser.baseUid]
					Alamofire.request(APIKey.sharedInstance.getApi(key:"/follow_user"), method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
						.responseString {
							response in switch response.result {
								
							case .success(let JSON):
								print("Success with JSON:\(JSON)")
								if JSON != "Success"{
								}
								else{
									self.followButton.setTitle("Followed", for: .normal)
								}
							case .failure(let error):
								print("Request failed with error: \(error)")
							}
					}
				}
			}else{ // Unfollow this one
				let firstTodoEndpoint: String = APIKey.sharedInstance.getApi(key: "/delete_user_followers/\(user.uid ?? 0)/\(sharedDarwinUser.baseUid)")
				print(firstTodoEndpoint)
				Alamofire.request(firstTodoEndpoint, method: .delete)
					.responseString { response in
						if response.result.error == nil{
							self.followButton.setTitle("Follow", for: .normal)
						}
						else{
							print("error calling DELETE")
							if let error = response.result.error {
								print("Error: \(error)")
							}
						}
				}
			}
		}
	}
	override func awakeFromNib() {
		if !sharedDarwinUser.loginStatus{
			followButton.isHidden = true
		}
		super.awakeFromNib()
	}
	
}
