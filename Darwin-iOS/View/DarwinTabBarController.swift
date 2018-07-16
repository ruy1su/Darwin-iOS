//
//  DarwinTabBarController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/15/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class DarwinTabBarController: UITabBarController, HearThisPlayerHolder {
	
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			if let viewControllers = viewControllers {
				for vc in viewControllers {
					configureTargetViewController(vc)
				}
			}
		}
	}
	
	private
	func configureTargetViewController(_ viewController: UIViewController?){
		if let playerHolder = viewController as? HearThisPlayerHolder {
			playerHolder.hearThisPlayer = hearThisPlayer
		}
	}
}
