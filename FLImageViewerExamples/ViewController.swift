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
        
        viewer.addAction(image: UIImage(systemName: "xmark.circle"), alignment: .topLeft, action: { _,_ in
            viewer.viewController?.dismiss(animated: true, completion: nil)
        })

        viewer.addAction(title: "Done", alignment: .topRight, action: { _,_ in
            viewer.viewController?.dismiss(animated: true, completion: nil)
        })
        
        viewer.addDeleteAction()
        
        guard let imageViewController = viewer.viewController else {
            return
        }
        imageViewController.modalPresentationStyle = .fullScreen
        self.present(imageViewController, animated: true, completion: nil)
    }
}

