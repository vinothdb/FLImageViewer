//
//  ImageViewer.swift
//  FLImageViewer
//
//  Created by Vinoth on 13/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

public enum FLAlignment {
    case topLeft, topRight, bottomLeft, bottomRight
}

public struct FLImageViewerConfig {
    
    public var showImageTileList : Bool = true
    public var tileViewSize: CGFloat = 30
    
    public init() {
        
    }
}

struct FLImage {
    
    let uniqueKey: String
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        self.uniqueKey = String.random(length: 10)
    }
    
    static func fl_images(images:[UIImage]) -> [FLImage] {
        
        var fl_images: [FLImage] = []
        for image in images {
            fl_images.append(FLImage(image: image))
        }
        return fl_images
    }
    
    static func toUIImage(images:[FLImage]) -> [UIImage] {
        return images.map{ $0.image }
    }
}

protocol FLDataSource : class {
    
    func fl_actions() -> [(button:FLButton, align:FLAlignment)]
    func fl_images() -> [FLImage]
    func fl_currentImageIndex() -> Int
    
    func fl_tileViewSize() -> CGFloat
    func fl_shouldShowTileList() -> Bool
}

public class FLImageViewer {
    
    private var images: [FLImage]
//    {
//        didSet {
//            self.imageViewerController?.images = self.images
//        }
//    }
    private var config : FLImageViewerConfig
//    {
//        didSet {
//            self.imageViewerController?.tileCellSize = self.config.showImageTileList ? self.config.tileViewSize : 0
//        }
//    }
    private var actions : [(button:FLButton, align:FLAlignment)] = []
//    {
//        didSet {
////            self.imageViewerController?.actions = self.actions
//        }
//    }
    
    private var deleteButton: FLButton?
    
    private weak  var imageViewerController: FLViewerController?
//        = { [weak self] in
//        guard let viewcontroller: FLViewerController = FLViewControllers.ImageViewer.instantiate() else {
//            fatalError("FLImageViewer: Could not instantiate ViewController")
//        }
//        viewcontroller.tileCellSize = self?.config.showImageTileList ?? true ? self?.config.tileViewSize ?? 30 : 0
//        viewcontroller.images = self?.images ?? []
//        viewcontroller.actions = self?.actions ?? []
//
//        return viewcontroller
//    }()
    
    private init(images:[UIImage] = [], config: FLImageViewerConfig = FLImageViewerConfig()) {
        self.config = config
        self.images = FLImage.fl_images(images: images)
    }
    
    public static var shared = FLImageViewer()
    
    public func setImages(images:[UIImage]) {
        self.images = FLImage.fl_images(images: images)
    }
    public func setConfig(config: FLImageViewerConfig) {
        self.config = config
    }
    
    public func presentView(onView: UIViewController) {
        
        self.imageViewerController = FLViewControllers.ImageViewer.instantiate()
        self.imageViewerController?.delegate = self
  
        onView.present(imageViewerController!, animated: true, completion: nil)
    }
    
    public func dismiss() {
        imageViewerController?.dismiss(animated: true, completion: nil)
        
        imageViewerController = nil
        self.images = []
    }
    
    private func reloadView() {
        self.deleteButton?.isHidden = self.images.count <= 1
        self.imageViewerController?.reloadImages(images: self.images)
    }
    
    deinit {
        print("Deinit called on viewer")
    }
}

//MARK:- Public Actions
public extension FLImageViewer {
    
//    var viewController : UIViewController {
//        get {
//            return self.imageViewerController
//        }
//    }
    
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
                         alignment: FLAlignment = .topRight,
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
                                     cornerRadius: cornerRadius) { [weak self] in
                                        
                                        guard !(self?.images.isEmpty ?? true), let currentIndex = self?.fl_currentImageIndex() else {
                                            return
                                        }
                                        
                                        self?.images.remove(at: currentIndex)
                                        self?.reloadView()
                                        completion?(currentIndex)
        }
        self.deleteButton = action
        self.deleteButton?.isHidden = self.images.count <= 1
        
        self.actions.append((action, alignment))
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
    func addAction(title: String? = nil,
                   image: UIImage? = nil,
                   alignment: FLAlignment,
                   textColor: UIColor? = nil,
                   backgroundColor: UIColor = .clear,
                   width: CGFloat? = nil,
                   cornerRadius: CornerRadius? = nil,
                   contentMode: UIView.ContentMode = .scaleAspectFit,
                   action: @escaping ((_ images: [UIImage], _ currentImageIndex: Int)-> Void)) {
        
        let action = FLButton.button(title: title,
                                     icon: image,
                                     textColor: textColor,
                                     backgroundColor: backgroundColor,
                                     cornerRadius: cornerRadius) { [weak self] in
                                        
                                        guard let currentIndex = self?.fl_currentImageIndex() else {
                                            return
                                        }
                                        action(FLImage.toUIImage(images: self?.images ?? []), currentIndex)
        }
        
        self.actions.append((action, alignment))
    }
}

extension FLImageViewer: FLDataSource {
    
    func fl_tileViewSize() -> CGFloat {
        return self.config.tileViewSize
    }
    
    func fl_shouldShowTileList() -> Bool {
        return self.config.showImageTileList
    }
    
    
    func fl_actions() -> [(button: FLButton, align: FLAlignment)] {
        return self.actions
    }
    
    func fl_images() -> [FLImage] {
        return self.images
    }
    
    func fl_currentImageIndex() -> Int {
        return 0
//        return self.imageViewerController?.viewerTable.indexPathForRow(at: self.viewerTable.contentOffset)?.row
    }
}
