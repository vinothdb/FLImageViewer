//
//  FLButton.swift
//  FLImageViewer
//
//  Created by Vinoth on 19/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

class FLButton : UIButton {
    
    var action : (()->Void)? = nil
    
    class func button(title: String? = nil,
                      icon: UIImage? = nil,
                      backgroundColor: UIColor = .clear,
                      cornerRadius: CGFloat = 0,
                      action: @escaping (()-> Void)) -> FLButton {
        
        let button = FLButton(type: .custom)
        let buttonWidth = title != nil ? FLSizeForActionWithTitle : FLSizeForActionWithIcon
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addConstraint(button.widthAnchor.constraint(lessThanOrEqualToConstant: buttonWidth))
    
        button.backgroundColor = backgroundColor
        button.tintColor = .white
        
        if cornerRadius != 0 {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = cornerRadius
        }
        
        if let titleText = title {
            button.setTitle(titleText, for: .normal)
            button.sizeToFit()
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.7
        }
        if let image = icon {
            button.setImage(image, for: .normal)
        }
        button.action = action
        
        button.addTarget(button, action: #selector(button.didButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    @objc func didButtonTapped() {
        self.action?()
    }
}
