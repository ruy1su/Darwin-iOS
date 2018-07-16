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
		guard let rvc = self.window?.rootViewController as? HearThisPlayerHolder else {fatalError()}
		rvc.hearThisPlayer = HearThisPlayer()
		return true
	}

}

