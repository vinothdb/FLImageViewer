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
    
    fileprivate var actions : [(button:FLButton, align:Alignment)] = []
    
    public init(images: [UIImage]) {
        self.images = images
    }
    
    public func addAction(title: String? = nil,
                             image: UIImage? = nil,
                             alignment: Alignment,
                             backgroundColor: UIColor = .clear,
                             cornerRadius: CGFloat = 0,
                             action: @escaping (()-> Void)) {
        
        self.actions.append((FLButton.button(with: image,
                                             backgroundColor: backgroundColor,
                                             cornerRadius: cornerRadius,
                                             action: action),alignment))
    }
}

class FLImage {
    
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
}

public class FLImageViewer {

    private var images: [FLImage]
    private var config : FLImageViewerConfig
    
//    private var imageViewerController : FLViewerController?
    
    private lazy var imageViewerController: FLViewerController? = {
        return FLViewControllers.ImageViewer.instantiate()
    }()
    
    public init(config: FLImageViewerConfig) {
        self.config = config
        self.images = FLImage.fl_images(images: config.images)
    }
}

//MARK:- Public Actions
public extension FLImageViewer {
    
    var viewController : UIViewController? {
        
        guard let imageViewer : FLViewerController = self.imageViewerController else {
            print("⚠️⚠️⚠️ FLImageViewer : Unable to initiate view ⚠️⚠️⚠️")
            return nil
        }
        
        imageViewer.tileCellSize = self.config.showImageTileList ? self.config.tileViewSize : 0
        imageViewer.images = self.images
        imageViewer.actions = self.config.actions
        
        return imageViewer
    }
}
