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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        guard let view = self.viewFromXib() else {
            return
        }
        self.addSubview(view)
        
        var constraints : [NSLayoutConstraint] = []
        constraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
        constraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        constraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        
        self.addConstraints(constraints)
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
}
