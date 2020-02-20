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
    
    class func button(with icon: UIImage? = nil,
                      backgroundColor: UIColor = .clear,
                      cornerRadius: CGFloat = 0,
                      action: @escaping (()-> Void)) -> FLButton {
        
        let button = FLButton(type: .custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addConstraint(button.widthAnchor.constraint(equalToConstant: FLActionButtonSize))
    
        button.backgroundColor = backgroundColor
        
        if cornerRadius != 0 {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = cornerRadius
        }
        
        button.setImage(icon, for: .normal)
        button.action = action
        
        button.addTarget(button, action: #selector(button.didButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    @objc func didButtonTapped() {
        self.action?()
    }
}
