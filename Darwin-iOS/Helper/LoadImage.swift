//
//  LoadImage.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

extension Podcast {
	func loadPodcastImage(completion: @escaping ((UIImage?) -> (Void))) {
		guard let imageURL = coverArtURL,
			let file = Bundle.main.path(forResource: imageURL.absoluteString, ofType:"jpg") else {
				return
		}
		
		DispatchQueue.global(qos: .background).async {
			let image = UIImage(contentsOfFile: file)
			DispatchQueue.main.async {
				completion(image)
			}
		}
	}
}
