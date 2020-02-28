//
//  FLImageView.swift
//  FLImageViewer
//
//  Created by Vinoth on 19/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

class FLImageView : UIView {
    
//    @IBOutlet var viewFromXib: UIView!
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        guard let view = self.viewFromXib() else {
            return
        }
        self.addSubview(view)
        
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    var image : UIImage? {
        didSet {
            self.imageView?.image = self.image
           
        }
    }
    
    override var contentMode: UIView.ContentMode {
        get {
            return super.contentMode
        }
        set(value) {
            super.contentMode = value
            self.imageView?.contentMode = self.contentMode
        }
    }
    
    func disableZoom() {
        self.containerScrollView.isUserInteractionEnabled = false
    }
    
    func resetZoom() {
        self.containerScrollView.zoomScale = 1
    }
}

extension FLImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}
