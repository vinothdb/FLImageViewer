//
//  FLButton.swift
//  FLImageViewer
//
//  Created by Vinoth on 19/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

public class FLButton: UIButton {
    
    var action: (()->Void)? = nil
    
	func configureButton(title: String? = nil,
						 icon: UIImage? = nil,
						 textColor: UIColor? = nil,
						 backgroundColor: UIColor = .clear,
						 cornerRadius: CornerRadius? = nil,
						 contentMode: UIView.ContentMode = .scaleAspectFit) {

		let buttonWidth = (icon != nil ? FLSizeConstants.action : FLSizeConstants.actionTitle)
		translatesAutoresizingMaskIntoConstraints = false
		self.backgroundColor = backgroundColor
		tintColor = textColor ?? FLAppColor.content
		
		if icon == nil, let titleText = title {
			setTitle(titleText, for: .normal)
			setTitleColor(textColor ?? FLAppColor.content, for: .normal)
			sizeToFit()
			titleLabel?.adjustsFontSizeToFitWidth = true
			titleLabel?.minimumScaleFactor = 0.7
			widthAnchor.constraint(lessThanOrEqualToConstant: buttonWidth).isActive = true
		}
		
		if let image = icon {
			setImage(image, for: .normal)
			widthAnchor.constraint(equalToConstant: image.size.width).isActive = true
			imageView?.contentMode = contentMode
			setTitle(nil, for: .normal)
		}

		if let cornerRadius = cornerRadius {
			layer.masksToBounds = true
			switch cornerRadius {
			case .circle:
				layer.cornerRadius = frame.height / 2
			case .custom(let radius):
				layer.cornerRadius = radius
			}
		}
	}
	
    @objc func didButtonTapped() {
        self.action?()
    }
}

extension FLButton {
	
	public class func button(title: String? = nil,
							 icon: UIImage? = nil,
							 textColor: UIColor? = nil,
							 backgroundColor: UIColor = .clear,
							 cornerRadius: CornerRadius? = nil,
							 contentMode: UIView.ContentMode = .scaleAspectFit,
							 action: @escaping (()-> Void)) -> FLButton {
		
		let button = FLButton(type: .custom)
		button.contentVerticalAlignment = .center
		button.contentHorizontalAlignment = .center
		button.configureButton(title: title,
							   icon: icon,
							   textColor: textColor,
							   backgroundColor: backgroundColor,
							   cornerRadius: cornerRadius,
							   contentMode: contentMode)
		button.action = action
		
		button.addTarget(button, action: #selector(button.didButtonTapped), for: .touchUpInside)
		
		return button
	}
}
