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
	
	lazy var imageViewContainer: UIView = {
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		return containerView
	}()
	
	lazy var imageViewVC: FLViewerController = FLViewControllers.ImageViewer.instantiate() as! FLViewerController
	
	lazy var sendButton: FLButton = {
		let button: FLButton = FLButton.button(title: "Send",
											  icon: nil,
											  textColor: .white,
											  backgroundColor: .blue,
											  cornerRadius: .custom(25)) {
			
			let currentIndex = self.currentImageIndex()
			self.delegate?.didSelect(images: self.images)
		}
		return button
	}()
	
	lazy var toolbarStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [FLTextView.create(), sendButton])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
	weak var delegate: FLImageViewDelegate? 
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		self.view.backgroundColor = bgColor
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
	
	private func setupView() {
		view.addSubview(toolbarStackView)
		NSLayoutConstraint.activate([
			toolbarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			toolbarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			toolbarStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			toolbarStackView.heightAnchor.constraint(equalToConstant: 50)
		])
		addImageViewContainer()
	}
	
	private func addImageViewContainer() {
		self.view.addSubview(imageViewContainer)
		NSLayoutConstraint.activate([
			imageViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
			imageViewContainer.bottomAnchor.constraint(equalTo: toolbarStackView.topAnchor),
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
