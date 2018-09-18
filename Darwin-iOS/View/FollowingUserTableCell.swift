//
//  FollowingUserTableCell.swift
//  Darwin-iOS
//
//  Created by Zenos on 9/11/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import Alamofire

class FollowingUserTableCell: UITableViewCell {
	
	var user: User!
	
	@IBOutlet weak var userImage: UIImageView!
	@IBOutlet weak var userName: UILabel!

	override func awakeFromNib() {
		if !sharedDarwinUser.loginStatus{
		}
		super.awakeFromNib()
	}
}
