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
                      width: CGFloat? = nil,
                      cornerRadius: CornerRadius? = nil,
                      contentMode: UIView.ContentMode = .scaleAspectFit,
                      action: @escaping (()-> Void)) -> FLButton {
        
        let button = FLButton(type: .custom)
        let buttonWidth = width ?? (title != nil ? FLSizeConstants.actionTitle : FLSizeConstants.action)
        
        button.translatesAutoresizingMaskIntoConstraints = false
    
        button.backgroundColor = backgroundColor
        button.tintColor = textColor ?? FLAppColor.content
        
        if let cornerRadius = cornerRadius {
            button.layer.masksToBounds = true
            switch cornerRadius {
            case .circle:
                button.layer.cornerRadius = buttonWidth/2
            case .custom(let radius):
                button.layer.cornerRadius = radius
            }
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
            button.imageView?.contentMode = .scaleAspectFill
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
