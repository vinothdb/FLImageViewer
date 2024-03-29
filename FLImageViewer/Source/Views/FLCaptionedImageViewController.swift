//
//  FLCaptionedImageViewController.swift
//  FLImageViewer
//
//  Created by Deepika on 05/04/21.
//  Copyright © 2021 Vinoth. All rights reserved.
//

import UIKit

class FLCaptionedImageViewController: UIViewController {
	
	let bgColor: UIColor = .white
	let toolbarBgColor: UIColor = .white
	var toolbarRequiredHeight: CGFloat = 50
	let toolbarItemDefaultHeight: CGFloat = 50
	
	lazy var imageViewContainer: UIView = {
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		return containerView
	}()
	
	lazy var imageViewVC: FLViewerController = {
		let vc = FLViewControllers.ImageViewer.instantiate() as! FLViewerController
		vc.delegate = self
		return vc
	}()
	
	lazy var sendButton: FLButton = {
		let button: FLButton = FLButton.button(title: "Send",
											  icon: nil,
											  textColor: .white,
											  backgroundColor: .blue,
											  cornerRadius: .custom(10)) {
			
			let currentIndex = self.currentImageIndex()
			self.interfaceDelegate?.didSelect(images: self.images)
		}
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	lazy var captionTextView: FLTextView = {
		let captionView = FLTextView.create()
		captionView.translatesAutoresizingMaskIntoConstraints = false
		captionView.textViewDelegate = self
		return captionView
	}()
	
	lazy var toolbarStackView: UIStackView = {

		func getSpacer(width: CGFloat) -> UIView {
			let spacer = UIView()
			spacer.translatesAutoresizingMaskIntoConstraints = false
			spacer.backgroundColor = .clear
			spacer.widthAnchor.constraint(equalToConstant: width).isActive = true
			return spacer
		}

		let leading = getSpacer(width: 10)
		let trailing = getSpacer(width: 10)
		
		let stackView = UIStackView(arrangedSubviews: [leading, captionTextView, sendButton, trailing])
		stackView.spacing = 10
		stackView.translatesAutoresizingMaskIntoConstraints = false

		// prior to iOS 14 can't add background color to stack view since it is a non-rendering view
		if #available(iOS 14, *) {
			stackView.backgroundColor = toolbarBgColor
		} else {
			stackView.addBackground(color: toolbarBgColor)
		}
		return stackView
	}()
	
	lazy var toolbarItemBottomConstraint: NSLayoutConstraint = {
		return self.toolbarStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
	}()
	
	lazy var imageViewBottomConstraint: NSLayoutConstraint = {
		return imageViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor,
														  constant: -(toolbarItemDefaultHeight + 20))
	}()
	
	lazy var toolbarItemHeightConstraint: NSLayoutConstraint = {
		return toolbarStackView.heightAnchor.constraint(equalToConstant: toolbarItemDefaultHeight)
	}()
	
	weak var interfaceDelegate: FLImageViewDelegate? 
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		self.view.backgroundColor = bgColor
		registerNotifications()
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		tapGesture.cancelsTouchesInView = false
		view.addGestureRecognizer(tapGesture)
    }
	
	deinit {
		unregisterNotifications()
	}
	
	func configureSendButton(title: String? = nil,
							 image: UIImage? = nil,
							 textColor: UIColor? = nil,
							 backgroundColor: UIColor = .clear,
							 cornerRadius: CornerRadius? = nil,
							 contentMode: UIView.ContentMode = .scaleAspectFit) {
		sendButton.configureButton(title: title,
								   icon: image,
								   textColor: textColor,
								   backgroundColor: backgroundColor,
								   cornerRadius: cornerRadius,
								   contentMode: contentMode)
	
	}
	
	func registerNotifications() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardWillShow(_:)),
											   name: UIResponder.keyboardWillShowNotification,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(keyboardWillDismiss(_:)),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)
	}
	
	func unregisterNotifications() {
		NotificationCenter.default.removeObserver(self)
	}
	
	@objc
	func dismissKeyboard() {
		captionTextView.resignFirstResponder()
	}
	
	func resizeToolbar() {
		toolbarRequiredHeight = captionTextView.expectedHeight
		let toolbarHeight = max(toolbarRequiredHeight, toolbarItemDefaultHeight)
		toolbarItemHeightConstraint.constant = toolbarHeight
		view.layoutIfNeeded()
	}
}

// MARK: - Conforming to FLImageViewProtocol
extension FLCaptionedImageViewController: FLImageViewProtocol {
	var images: [FLImage] {
		get {
			return imageViewVC.images
		}
		set {
			imageViewVC.images = newValue
		}
	}
	
	var actions: [FLAction] {
		get {
			return imageViewVC.actions
		}
		set {
			imageViewVC.actions = newValue
		}
	}
	
	var tileCellSize: CGFloat {
		get {
			imageViewVC.tileCellSize
		}
		set {
			imageViewVC.tileCellSize = newValue
		}
	}
	
	var currentImage: FLImage {
		return images[currentImageIndex()]
	}
	
	func currentImageIndex() -> Int {
		return imageViewVC.currentImageIndex()
	}
	
	func reloadImages(images: [FLImage]) {
		self.images = images
		self.imageViewVC.reloadTables()
	}
}

// MARK: - Adding subviews and setting constraints
extension FLCaptionedImageViewController {
	
	private func setupView() {
		addImageViewContainer()
		addToolbar()
	}
	
	private func addToolbar() {
		view.addSubview(toolbarStackView)
		NSLayoutConstraint.activate([
			toolbarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			toolbarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			toolbarItemBottomConstraint,
			toolbarItemHeightConstraint,
		])
	}
	
	private func addImageViewContainer() {
		self.view.addSubview(imageViewContainer)
		NSLayoutConstraint.activate([
			imageViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
			imageViewBottomConstraint,
		])
		addImageView()
	}
	
	private func addImageView() {
		guard let imageView = self.imageViewVC.view else { return }
		addChild(self.imageViewVC)
		imageView.frame = imageViewContainer.bounds
		imageViewContainer.addSubview(imageView)
		self.imageViewVC.didMove(toParent: self)
	}
}

// MARK: - Keyboard handling
extension FLCaptionedImageViewController {
	
	@objc
	func keyboardWillShow(_ notification: Notification) {
		guard let rect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
		toolbarItemBottomConstraint.constant = -rect.size.height
		toolbarStackView.becomeFirstResponder()
		
		self.view.layoutIfNeeded()
	}
	
	@objc
	func keyboardWillDismiss(_ notification: Notification) {
		toolbarItemBottomConstraint.constant = -20
		self.view.layoutIfNeeded()
	}
}

// MARK: - FLTextViewDelegate conformation
extension FLCaptionedImageViewController: FLTextViewDelegate {
	func didChangeCaption(_ caption: String) {
		currentImage.caption = caption
		resizeToolbar()
	}
}

// MARK: - FLViewControllerDelegate conformation
extension FLCaptionedImageViewController: FLViewControllerDelegate {
	func didChangeSelectedImageIndex() {
		let caption = self.currentImage.caption ?? ""
		self.captionTextView.text = caption
		self.captionTextView.shouldShowPlaceholder(caption.isEmpty)
		self.resizeToolbar()
	}
}
