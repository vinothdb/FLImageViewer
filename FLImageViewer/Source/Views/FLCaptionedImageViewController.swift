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
											  cornerRadius: .custom(25)) {
			
			let currentIndex = self.currentImageIndex()
			self.interfaceDelegate?.didSelect(images: self.images)
		}
		return button
	}()
	
	lazy var captionTextView: FLTextView = {
		let captionView = FLTextView.create()
		captionView.textViewDelegate = self
		return captionView
	}()
	
	lazy var toolbarStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [captionTextView, sendButton])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
	lazy var toolbarItemBottomConstraint: NSLayoutConstraint = {
		return self.toolbarStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
	}()
	
	weak var interfaceDelegate: FLImageViewDelegate? 
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		self.view.backgroundColor = bgColor
		self.toolbarStackView.backgroundColor = toolbarBgColor
		registerNotifications()
		view.addGestureRecognizer(UITapGestureRecognizer(target: self,
														 action: #selector(dismissKeyboard)))
    }
	
	deinit {
		unregisterNotifications()
	}
	
	func configureSendButton(title: String? = nil,
							 image: UIImage? = nil,
							 textColor: UIColor? = nil,
							 backgroundColor: UIColor = .clear,
							 width: CGFloat? = nil,
							 cornerRadius: CornerRadius? = nil,
							 contentMode: UIView.ContentMode = .scaleAspectFit) {
		sendButton.configureButton(title: title,
								   icon: image,
								   textColor: textColor,
								   backgroundColor: backgroundColor,
								   width: width,
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
		guard let viewerTable = imageViewVC.viewerTable else { return 0 }
		return viewerTable.indexPathForRow(at: viewerTable.contentOffset)?.row ?? 0
	}
	
	func reloadImages(images: [FLImage]) {
		self.images = images
		self.imageViewVC.reloadTables()
	}
}

// MARK: - Adding subviews and setting constraints
extension FLCaptionedImageViewController {
	
	var toolbarItemHeight: CGFloat { return 50 }
	
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
			toolbarStackView.heightAnchor.constraint(equalToConstant: toolbarItemHeight)
		])
	}
	
	private func addImageViewContainer() {
		self.view.addSubview(imageViewContainer)
		NSLayoutConstraint.activate([
			imageViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
			imageViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor,
													   constant: -toolbarItemHeight),
		])
		addImageView()
	}
	
	private func addImageView() {
		guard let imageView = self.imageViewVC.view else { return }
		imageViewVC.willMove(toParent: self)
		addChild(self.imageViewVC)
		imageViewContainer.addSubview(imageView)
		let size = imageViewContainer.frame.size;
		imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
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
		toolbarItemBottomConstraint.constant = 0
		self.view.layoutIfNeeded()
	}
}

// MARK: - FLTextViewDelegate conformation
extension FLCaptionedImageViewController: FLTextViewDelegate {
	func didChangeCaption(_ caption: String) {
		currentImage.caption = caption
	}
}

// MARK: - FLViewControllerDelegate conformation
extension FLCaptionedImageViewController: FLViewControllerDelegate {
	func didChangeSelectedImageIndex() {
		captionTextView.text = currentImage.caption ?? ""
	}
}
