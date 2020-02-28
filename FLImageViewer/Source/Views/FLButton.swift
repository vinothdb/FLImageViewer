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
                      textColor: UIColor? = nil,
                      backgroundColor: UIColor = .clear,
                      cornerRadius: CGFloat = 0,
                      action: @escaping (()-> Void)) -> FLButton {
        
        let button = FLButton(type: .custom)
        let buttonWidth = title != nil ? FLSizeConstants.actionTitle : FLSizeConstants.action
        
        button.translatesAutoresizingMaskIntoConstraints = false
    
        button.backgroundColor = backgroundColor
        button.tintColor = textColor ?? FLAppColor.content
        button.contentMode = .scaleAspectFit
        
        if cornerRadius != 0 {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = cornerRadius
        }
        
        if let titleText = title {
            button.setTitle(titleText, for: .normal)
            button.setTitleColor(textColor ?? FLAppColor.content, for: .normal)
            button.sizeToFit()
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.7
            button.widthAnchor.constraint(lessThanOrEqualToConstant: buttonWidth).isActive = true
        }
        if let image = icon {
            button.setImage(image, for: .normal)
            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        }
        button.action = action
        
        button.addTarget(button, action: #selector(button.didButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    @objc func didButtonTapped() {
        self.action?()
    }
}
