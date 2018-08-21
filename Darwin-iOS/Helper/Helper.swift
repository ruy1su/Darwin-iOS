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
	static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
		let size = image.size
		
		let widthRatio  = targetSize.width  / size.width
		let heightRatio = targetSize.height / size.height
		
		// Figure out what our orientation is, and use that to form the rectangle
		var newSize: CGSize
		if(widthRatio > heightRatio) {
			newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
		} else {
			newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
		}
		
		// This is the rect that we've calculated out and this is what is actually used below
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		
		// Actually do the resizing to the rect using the ImageContext stuff
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		image.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
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

extension UIImage {
	func resizeImage(targetSize: CGSize) -> UIImage {
		let size = self.size
		let widthRatio  = targetSize.width  / size.width
		let heightRatio = targetSize.height / size.height
		let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		self.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
}

