//
//  Helper.swift
//  Darwin-iOS
//
//  Created by Zenos on 8/8/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

// Mark -: Helper Class
class Helper{
	static func matches(for regex: String!, in text: String!) -> [String] {
		do {
			let regex = try NSRegularExpression(pattern: regex, options: [])
			let nsString = text as NSString
			let results = regex.matches(in: text, range: NSMakeRange(0, nsString.length))
			return results.map { nsString.substring(with: $0.range)}
		} catch let error as NSError {
			print("invalid regex: \(error.localizedDescription)")
			return []
		}
	}
	
}

// Mark -: Take Snapshot of the image
extension UIView  {
	func makeSnapshot() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
		drawHierarchy(in: bounds, afterScreenUpdates: true)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}

// Mark -: Array extension to find unique items
extension Array where Element: Hashable {
	func removingDuplicates() -> [Element] {
		var addedDict = [Element: Bool]()
		
		return filter {
			addedDict.updateValue(true, forKey: $0) == nil
		}
	}
	
	mutating func removeDuplicates() {
		self = self.removingDuplicates()
	}
}
extension Sequence where Iterator.Element: Hashable {
	func unique() -> [Iterator.Element] {
		return Array(Set<Iterator.Element>(self))
	}
	
	func uniqueOrdered() -> [Iterator.Element] {
		return reduce([Iterator.Element]()) { $0.contains($1) ? $0 : $0 + [$1] }
	}
}
