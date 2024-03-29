//
//  ImageViewer.swift
//  FLImageViewer
//
//  Created by Vinoth on 13/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

public enum Alignment {
    case topLeft, topRight, bottomLeft, bottomRight
}

public class FLImageViewerConfig {
    
    public var showImageTileList : Bool = true
    public var tileViewSize: CGFloat = 30
    public var images : [UIImage]
    
    public init(images: [UIImage]) {
        self.images = images
    }
}

typealias FLAction = (button: FLButton, align: Alignment)

protocol FLImageViewProtocol: UIViewController {
	var interfaceDelegate: FLImageViewDelegate? { get set }
	var images: [FLImage] { get set }
	var actions: [FLAction] { get set }
	var tileCellSize: CGFloat { get set }
	func reloadImages(images: [FLImage])
	func currentImageIndex() -> Int
}

public protocol FLImageViewDelegate: AnyObject {
	func didSelect(images: [FLImage])
	func didTapCloseButton()
}

public class FLImageViewer {

    var images: [FLImage] {
        didSet {
            self.flImageViewController.images = self.images
        }
    }
    var config: FLImageViewerConfig {
        didSet {
            self.flImageViewController.tileCellSize = self.config.showImageTileList ? self.config.tileViewSize : 0
        }
    }
	
    var actions : [(button: FLButton, align: Alignment)] = [] {
        didSet {
            self.flImageViewController.actions = self.actions
        }
    }
    
    private var deleteButton: FLButton?
    
    private lazy var imageViewerController: FLViewerController = {
        guard let viewcontroller: FLViewerController = FLViewControllers.ImageViewer.instantiate() else {
            fatalError("FLImageViewer: Could not instantiate ViewController")
        }
        viewcontroller.tileCellSize = self.config.showImageTileList ? self.config.tileViewSize : 0
        viewcontroller.images = self.images
        viewcontroller.actions = self.actions
        
        return viewcontroller
    }()
	
	var flImageViewController: FLImageViewProtocol {
		return imageViewerController
	}
	
	public weak var delegate: FLImageViewDelegate? {
		didSet {
			flImageViewController.interfaceDelegate = delegate
		}
	}
    
	public init(config: FLImageViewerConfig) {
        self.config = config
        self.images = FLImage.fl_images(images: config.images)
    }
    
    private func reloadView() {
        self.deleteButton?.isHidden = self.images.count <= 1
        self.flImageViewController.reloadImages(images: self.images)
    }
	
	/// Adds action button to view.
	/// - Parameters:
	///   - title: Text to be displayed for action button. Defaults to nil.
	///   - image: Icon to use for action button. Defaults to nil
	///   - alignment: Alignment for action button.
	///   - textColor: Will be set as both title text and tint color
	///   - backgroundColor: BackgroundColor to use for action button. Defaults to clear colour
	///   - width: Action button width
	///   - cornerRadius: Action button corner radius
	///   - contentMode: Action button content mode. Same is set to button's imageView, incase if image passed.
	///   - action: Block to be executed when action button is tapped
	/// - Note:- List of actions will be sorted in the order it is added
	public func addAction(title: String? = nil,
				   image: UIImage? = nil,
				   alignment: Alignment,
				   textColor: UIColor? = nil,
				   backgroundColor: UIColor = .clear,
				   width: CGFloat? = nil,
				   cornerRadius: CornerRadius? = nil,
				   contentMode: UIView.ContentMode = .scaleAspectFit,
				   action: @escaping ((_ images: [FLImage], _ currentImageIndex: Int)-> Void)) {
		let action = FLButton.button(title: title,
									 icon: image,
									 textColor: textColor,
									 backgroundColor: backgroundColor,
									 cornerRadius: cornerRadius) {
			
			let currentIndex = self.flImageViewController.currentImageIndex()
			action(self.images, currentIndex)
		}
		
		self.actions.append((action, alignment))
	}
}

//MARK:- Public Actions
public extension FLImageViewer {
    
    var viewController: UIViewController {
        get {
            return self.flImageViewController
        }
    }
    
    /// Appends image to the view
    /// - Parameter images: Image to be appended
    func appendImage(_ image: UIImage) {
        self.images.append(FLImage(image: image))
        self.reloadView()
    }
    
    /// Appends collection of image to the view
    /// - Parameter images: List of images to be appended
    func appendImages(_ images: [UIImage]) {
        self.images.append(contentsOf: FLImage.fl_images(images: images))
        self.reloadView()
    }
    
    
    /// Inserts images to view at specified index
    /// - Parameters:
    ///   - images: Images to be inserted
    ///   - at: Index where to insert image
    func insertImage(_ images: [UIImage], at: Int) {
        self.images.insert(contentsOf: FLImage.fl_images(images: images), at: at)
        self.reloadView()
    }
    
    func replaceAll(with images: [UIImage]) {
        self.images = FLImage.fl_images(images: images)
        self.reloadView()
    }
    
    /// Adds delete button to the view
    /// - Parameters:
    ///   - title: Text to be displayed for delete button. Defaults to nil.
    ///   - image: Icon for delete button. Defaults to nil. If both title and image is sent nil, Uses system 'trash' image from iOS 13.
    ///   - alignment: Alignment for delete button. Defaults to 'topRight'
    ///   - backgroundColor: Delete button backgroundColor. Defaults to clear colour
    ///   - cornerRadius: Delete button corner radius. Defaults to 0
    ///   - completion: Completion block to be executed by the end of delete action
    /// - Note:- Last image cannot be deleted. Also Delete button will be sorted in the order the list of actions added.
    func addDeleteAction(title: String? = nil,
                         image: UIImage? = nil,
                         alignment: Alignment = .topRight,
                         textColor: UIColor? = nil,
                         backgroundColor: UIColor = .clear,
                         width: CGFloat? = nil,
                         cornerRadius: CornerRadius? = nil,
                         contentMode: UIView.ContentMode = .scaleAspectFit,
                         completion: ((_ deletedIndex: Int)-> Void)? = nil) {
        
        let image = (title == nil && image == nil) ? UIImage.systemImage("trash") : image
        
		let action = FLButton.button(title: title,
									 icon: image,
									 textColor: textColor,
									 backgroundColor: backgroundColor,
									 cornerRadius: cornerRadius) {
			
			guard self.images.count > 1 else {
				return
			}
			let currentIndex = self.flImageViewController.currentImageIndex()
			self.images.remove(at: currentIndex)
			self.reloadView()
			completion?(currentIndex)
		}
        self.deleteButton = action
        self.deleteButton?.isHidden = self.images.count <= 1
        
        self.actions.append((action, alignment))
    }
}
