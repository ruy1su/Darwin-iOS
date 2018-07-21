//
//  Constant.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/21/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class Constant {
	static let totalItem: CGFloat = 20
	
	static let column: CGFloat = 3
	
	static let minLineSpacing: CGFloat = 1.0
	static let minItemSpacing: CGFloat = 1.0
	
	static let offset: CGFloat = 1.0 // TODO: for each side, define its offset
	
	static func getItemWidth(boundWidth: CGFloat) -> CGFloat {
		
		let totalWidth = boundWidth - (offset + offset) - ((column - 1) * minItemSpacing)
		
		return totalWidth / column
	}
}
