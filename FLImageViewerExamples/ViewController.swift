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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func show() {
        
        let config = FLImageViewerConfig(images: images)
        config.showImageTileList = true
        
        let viewer = FLImageViewer(config: config)
        
        config.addAction(image: #imageLiteral(resourceName: "close"), alignment: .topRight, action: {
            viewer.viewController?.dismiss(animated: true, completion: nil)
        })
        
        guard let imageViewController = viewer.viewController else {
            return
        }
        imageViewController.modalPresentationStyle = .fullScreen
        self.present(imageViewController, animated: true, completion: nil)
    }
}

