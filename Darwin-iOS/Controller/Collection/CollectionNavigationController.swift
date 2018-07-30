//
//  CollectionNavigationController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/29/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class CollectionNavigationController: UINavigationController, HearThisPlayerHolder {
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			if let tvc = self.topViewController as? HearThisPlayerHolder{
				tvc.hearThisPlayer = hearThisPlayer
			}
		}
	}
	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		if let vc = viewController as? EpisodeListViewController {
			vc.hearThisPlayer = self.hearThisPlayer
		}
		super.pushViewController(viewController, animated: animated)
	}
	
}
