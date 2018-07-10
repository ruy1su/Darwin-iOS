//
//  ExpandingPlayerViewController.swift
//  Darwin-iOS
//
//  Created by Zenos on 7/9/18.
//  Copyright © 2018 Zixia. All rights reserved.
//

import UIKit

protocol ExpandingPlayerSourceProtocol: class {
	var originatingFrameInWindow: CGRect { get }
	var originatingCoverImageView: UIImageView { get }
}

class ExpandingPlayerViewController: UIViewController, PodcastSubscriber {
	
	// MARK: - Properties
	let primaryDuration = 0.2
	let backingImageEdgeInset: CGFloat = 15.0
	let cardCornerRadius: CGFloat = 10
	var currentPodcast: Podcast?
	weak var sourceView: ExpandingPlayerSourceProtocol!
	
	//scroller
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var stretchySkirt: UIView!
	//cover image
	@IBOutlet weak var coverImageContainer: UIView!
	@IBOutlet weak var coverArtImage: UIImageView!
	@IBOutlet weak var dismissChevron: UIButton!
	//
	//cover image constraints
	@IBOutlet weak var coverImageLeading: NSLayoutConstraint!
	@IBOutlet weak var coverImageTop: NSLayoutConstraint!
	@IBOutlet weak var coverImageBottom: NSLayoutConstraint!
	@IBOutlet weak var coverImageHeight: NSLayoutConstraint!
	//cover image constraints
	@IBOutlet weak var coverImageContainerTopInset: NSLayoutConstraint!
	
	//backing image
	var backingImage: UIImage?
	@IBOutlet weak var backingImageView: UIImageView!
	@IBOutlet weak var dimmerLayer: UIView!
	//add backing image constraints here
	@IBOutlet weak var backingImageTopInset: NSLayoutConstraint!
	@IBOutlet weak var backingImageLeadingInset: NSLayoutConstraint!
	@IBOutlet weak var backingImageTrailingInset: NSLayoutConstraint!
	@IBOutlet weak var backingImageBottomInset: NSLayoutConstraint!
	
	//lower module constraints
	@IBOutlet weak var lowerModuleTopConstraint: NSLayoutConstraint!
	
	//fake tabbar contraints
	var tabBarImage: UIImage?
	@IBOutlet weak var bottomSectionHeight: NSLayoutConstraint!
	@IBOutlet weak var bottomSectionLowerConstraint: NSLayoutConstraint!
	@IBOutlet weak var bottomSectionImageView: UIImageView!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	// MARK: - View Life Cycle
	override func awakeFromNib() {
		super.awakeFromNib()
		
		modalPresentationCapturesStatusBarAppearance = true //allow this VC to control the status bar appearance
		modalPresentationStyle = .overFullScreen //dont dismiss the presenting view controller when presented
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		backingImageView.image = backingImage
		scrollView.contentInsetAdjustmentBehavior = .never //dont let Safe Area insets affect the scroll view
		
		coverImageContainer.layer.cornerRadius = cardCornerRadius
		coverImageContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configureImageLayerInStartPosition()
		coverArtImage.image = sourceView.originatingCoverImageView.image
		configureCoverImageInStartPosition()
		stretchySkirt.backgroundColor = .white
		configureLowerModuleInStartPosition()
		configureBottomSection()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		animateBackingImageIn()
		animateImageLayerIn()
		animateCoverImageIn()
		animateLowerModuleIn()
		animateBottomSectionOut()
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? PodcastSubscriber {
			destination.currentPodcast = currentPodcast
		}
	}
}

// MARK: - IBActions
extension ExpandingPlayerViewController {
	
	@IBAction func dismissAction(_ sender: Any) {
		animateBackingImageOut()
		animateCoverImageOut()
		animateImageLayerOut() { _ in
			self.dismiss(animated: false)
		}
		animateLowerModuleOut()
		animateBottomSectionIn()
	}
	
}

//fake tab bar animation
extension ExpandingPlayerViewController {
	
	func configureBottomSection() {
		if let image = tabBarImage {
			bottomSectionHeight.constant = image.size.height
			bottomSectionImageView.image = image
		} else {
			bottomSectionHeight.constant = 0
		}
		view.layoutIfNeeded()
	}
	
	func animateBottomSectionOut() {
		if let image = tabBarImage {
			UIView.animate(withDuration: primaryDuration / 2.0) {
				self.bottomSectionLowerConstraint.constant = -image.size.height
				self.view.layoutIfNeeded()
			}
		}
	}
	
	func animateBottomSectionIn() {
		if tabBarImage != nil {
			UIView.animate(withDuration: primaryDuration / 2.0) {
				self.bottomSectionLowerConstraint.constant = 0
				self.view.layoutIfNeeded()
			}
		}
	}
}

//background image animation
extension ExpandingPlayerViewController {
	
	private func configureBackingImageInPosition(presenting: Bool) {
		let edgeInset: CGFloat = presenting ? backingImageEdgeInset: 0
		let dimmerAlpha: CGFloat = presenting ? 0.3: 0
		let cornerRadius: CGFloat = presenting ? cardCornerRadius: 0
		
		backingImageLeadingInset.constant = edgeInset
		backingImageTrailingInset.constant = edgeInset
		let aspectRatio = backingImageView.frame.height / backingImageView.frame.width
		backingImageTopInset.constant = edgeInset * aspectRatio
		backingImageBottomInset.constant = edgeInset * aspectRatio
		
		dimmerLayer.alpha = dimmerAlpha
		
		backingImageView.layer.cornerRadius = cornerRadius
	}
	
	private func animateBackingImage(presenting: Bool) {
		UIView.animate(withDuration: primaryDuration) {
			self.configureBackingImageInPosition(presenting: presenting)
			self.view.layoutIfNeeded() //IMPORTANT!
		}
	}
	
	func animateBackingImageIn() {
		animateBackingImage(presenting: true)
	}
	
	func animateBackingImageOut() {
		animateBackingImage(presenting: false)
	}
}

//Image Container animation.
extension ExpandingPlayerViewController {
	
	private var startColor: UIColor {
		return UIColor.white.withAlphaComponent(0.3)
	}
	
	private var endColor: UIColor {
		return .white
	}
	
	private var imageLayerInsetForOutPosition: CGFloat {
		let imageFrame = view.convert(sourceView.originatingFrameInWindow, to: view)
		let inset = imageFrame.minY - backingImageEdgeInset
		return inset
	}
	
	func configureImageLayerInStartPosition() {
		coverImageContainer.backgroundColor = startColor
		let startInset = imageLayerInsetForOutPosition
		dismissChevron.alpha = 0
		coverImageContainer.layer.cornerRadius = 0
		coverImageContainerTopInset.constant = startInset
		view.layoutIfNeeded()
	}
	
	func animateImageLayerIn() {
		UIView.animate(withDuration: primaryDuration / 4.0) {
			self.coverImageContainer.backgroundColor = self.endColor
		}
		
		UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseIn], animations: {
			self.coverImageContainerTopInset.constant = 0
			self.dismissChevron.alpha = 1
			self.coverImageContainer.layer.cornerRadius = self.cardCornerRadius
			self.view.layoutIfNeeded()
		})
	}
	
	func animateImageLayerOut(completion: @escaping ((Bool) -> Void)) {
		let endInset = imageLayerInsetForOutPosition
		
		UIView.animate(withDuration: primaryDuration / 4.0, delay: primaryDuration , options: [.curveEaseOut], animations: {
			self.coverImageContainer.backgroundColor = self.startColor
		}, completion: { finished in
			completion(finished)
		})
		
		UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseOut], animations: {
			self.coverImageContainerTopInset.constant = endInset
			self.dismissChevron.alpha = 0
			self.coverImageContainer.layer.cornerRadius = 0
			self.view.layoutIfNeeded()
		})
	}
}

//cover image animation
extension ExpandingPlayerViewController {
	
	func configureCoverImageInStartPosition() {
		let originatingImageFrame = sourceView.originatingCoverImageView.frame
		coverImageHeight.constant = originatingImageFrame.height
		coverImageLeading.constant = originatingImageFrame.minX
		coverImageTop.constant = originatingImageFrame.minY
		coverImageBottom.constant = originatingImageFrame.minY
	}
	
	func animateCoverImageIn() {
		let coverImageEdgeContraint: CGFloat = 30
		let endHeight = coverImageContainer.bounds.width - coverImageEdgeContraint * 2
		UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseIn], animations: {
			self.coverImageHeight.constant = endHeight
			self.coverImageLeading.constant = coverImageEdgeContraint
			self.coverImageTop.constant = coverImageEdgeContraint
			self.coverImageBottom.constant = coverImageEdgeContraint
			self.view.layoutIfNeeded()
		})
	}
	
	func animateCoverImageOut() {
		UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseOut], animations: {
			self.configureCoverImageInStartPosition()
			self.view.layoutIfNeeded()
		})
	}
}

//lower module animation
extension ExpandingPlayerViewController {
	
	private var lowerModuleInsetForOutPosition: CGFloat {
		let bounds = view.bounds
		return bounds.height - bounds.width
	}
	
	func configureLowerModuleInStartPosition() {
		lowerModuleTopConstraint.constant = lowerModuleInsetForOutPosition
	}
	
	func animateLowerModule(isPresenting: Bool) {
		let topInset = isPresenting ? 0 : lowerModuleInsetForOutPosition
		UIView.animate(withDuration: primaryDuration , delay: 0 , options: [.curveEaseIn], animations: {
			self.lowerModuleTopConstraint.constant = topInset
			self.view.layoutIfNeeded()
		})
	}
	
	func animateLowerModuleOut() {
		animateLowerModule(isPresenting: false)
	}
	
	func animateLowerModuleIn() {
		animateLowerModule(isPresenting: true)
	}
}
