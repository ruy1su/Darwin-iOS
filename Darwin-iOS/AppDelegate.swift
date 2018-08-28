//
//  AppDelegate.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/7/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//		UINavigationBar.appearance().barTintColor = UIColor(rgb: 0x37474F)
//		UINavigationBar.appearance().tintColor = UIColor.white
//		UINavigationBar.appearance().titleTextAttributes = [kCTForegroundColorAttributeName:UIColor.white] as [NSAttributedStringKey : Any]
		
		guard let rvc = self.window?.rootViewController as? HearThisPlayerHolder else {fatalError()}
		rvc.hearThisPlayer = HearThisPlayer()
		let memoryCapacity = 500 * 1024 * 1024
		let diskCapacity = 500 * 1024 * 1024
		let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "darwin")
		URLCache.shared = cache
		return true
	}
	
}

