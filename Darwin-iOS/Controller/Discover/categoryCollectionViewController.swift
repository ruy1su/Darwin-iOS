//
//  categoryCollectionViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 8/27/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

class CategoryCollectionViewController: UIViewController,HearThisPlayerObserver,HearThisPlayerHolder,PodcastSelectionObserver{

	@IBOutlet weak var collectionView: UICollectionView!
	
	var delegate: SelectedCollectionItemDelegate?
	var currentCat: String = ""
	var hearThisPlayer: HearThisPlayerType? {
		didSet{
			hearThisPlayer?.registerObserver(observer: self)
		}
	}
	var datasource: PodcastCollectionDatasource!
	var API = APIKey.sharedInstance.getApi(key:"/api_pod_cat/Arts")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = currentCat
		datasource = PodcastCollectionDatasource(collectionView: self.collectionView!)
		print(API)
		datasource.load(api: API)
		datasource.registerSelectionObserver(observer: self)
	}
	
	func selected(_ podcast: DataStack, on: IndexPath) {
		self.delegate?.selectedCollectionItem(podcast: podcast, index: on)
	}
}
