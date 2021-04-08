//
//  ViewController.swift
//  FLImageViewerExamples
//
//  Created by Vinoth on 20/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit
import FLImageViewer

class ViewController: UIViewController {
    
    let images = [#imageLiteral(resourceName: "monarch.png"),#imageLiteral(resourceName: "iphone"),#imageLiteral(resourceName: "fruits.png"),#imageLiteral(resourceName: "flowers")]
	var imageViewer: FLCaptionedImageViewer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func show() {
        let config = FLImageViewerConfig(images: images)
        config.tileViewSize = 50
        
		imageViewer = FLCaptionedImageViewer(config: config)

//        if #available(iOS 13.0, *) {
//            imageViewer.addAction(image: UIImage(systemName: "xmark"), alignment: .topLeft) { (_, _) in
//                imageViewer.viewController.dismiss(animated: true, completion: nil)
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        imageViewer.addDeleteAction()
		imageViewer.addCloseButton()
		imageViewer.configureCaptionView(placeHolder: "Add a caption here..")
		imageViewer.delegate = self
        
        if #available(iOS 13.0, *) {
            imageViewer.viewController.isModalInPresentation = true
        }
        self.present(imageViewer.viewController, animated: true, completion: nil)
    }
}

extension ViewController: FLImageViewDelegate {
	func didSelect(images: [FLImage]) {
		images.forEach { (image) in
			print(image.caption ?? "caption not present!!")
		}
	}
	
	func didTapCloseButton() {
		imageViewer.viewController.dismiss(animated: true, completion: nil)
	}
}
