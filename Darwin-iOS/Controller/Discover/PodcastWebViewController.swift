//
//  PodcastWebViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 9/3/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit
import WebKit

class PodcastWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, HearThisPlayerHolder, HearThisPlayerObserver {
	var hearThisPlayer: HearThisPlayerType? {
		didSet {
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	var urlString: String = "https://librivox.org/a-birding-on-a-bronco-by-florence-a-merriam/"
	var webView: WKWebView!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
		guard let url = URL(string: urlString) else {
			self.alert(message: "Cannot find this Web Page")
			return
		}
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
		

	}
}
