//
//  SnapShot.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/9/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

extension UIView  {
	func makeSnapshot() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
		drawHierarchy(in: bounds, afterScreenUpdates: true)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}
