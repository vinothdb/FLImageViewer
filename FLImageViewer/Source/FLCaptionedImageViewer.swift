//
//  FLCaptionedImageViewer.swift
//  FLImageViewer
//
//  Created by Deepika on 05/04/21.
//  Copyright © 2021 Vinoth. All rights reserved.
//

import UIKit

public class FLCaptionedImageViewer: FLImageViewer {
	
	override var flImageViewController: FLImageViewProtocol {
		return self.captionedImageViewerController
	}
	
	private lazy var captionedImageViewerController: FLCaptionedImageViewController = {
		let viewcontroller: FLCaptionedImageViewController = FLCaptionedImageViewController()
		viewcontroller.tileCellSize = self.config.showImageTileList ? self.config.tileViewSize : 0
		viewcontroller.images = self.images
		viewcontroller.actions = self.actions
		return viewcontroller
	}()
	
	// MARK: Making this func inaccessible from the captioned image view
	@available(*, unavailable)
	public override func addAction(title: String? = nil, image: UIImage? = nil, alignment: Alignment, textColor: UIColor? = nil, backgroundColor: UIColor = .clear, width: CGFloat? = nil, cornerRadius: CornerRadius? = nil, contentMode: UIView.ContentMode = .scaleAspectFit, action: @escaping (([FLImage], Int) -> Void)) { }
	
	public func configureSendButton(title: String? = nil,
							 image: UIImage? = nil,
							 textColor: UIColor? = nil,
							 backgroundColor: UIColor = .clear,
							 width: CGFloat? = nil,
							 cornerRadius: CornerRadius? = nil,
							 contentMode: UIView.ContentMode = .scaleAspectFit) {
		let title: String? = (title == nil && image == nil) ? "Send" : title
		captionedImageViewerController.configureSendButton(title: title,
														   image: image,
														   textColor: textColor,
														   backgroundColor: backgroundColor,
														   width: width,
														   cornerRadius: cornerRadius,
														   contentMode: contentMode)
		
	}
	
	public func addCloseButton(title: String? = nil,
						image: UIImage? = nil,
						textColor: UIColor? = nil,
						backgroundColor: UIColor = .clear,
						width: CGFloat? = nil,
						cornerRadius: CornerRadius? = nil,
						contentMode: UIView.ContentMode = .scaleAspectFit) {
		let title: String? = (title == nil && image == nil) ? "close" : title
		
		let action = FLButton.button(title: title,
									 icon: image,
									 textColor: textColor,
									 backgroundColor: backgroundColor,
									 cornerRadius: cornerRadius) {
			
			self.delegate?.didTapCloseButton()
		}
		
		self.actions.append((action, .topLeft))
	}
	
	public func configureCaptionView(placeHolder: String? = "Add Caption",
									 config: FLTextViewConfiguration = FLTextViewConfiguration()) {
		captionedImageViewerController.captionTextView.configure(withPlaceholder: placeHolder,
																 config)
	}
}
