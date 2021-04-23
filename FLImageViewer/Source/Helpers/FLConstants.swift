//
//  FLDefault.swift
//  FLImageViewer
//
//  Created by Vinoth on 13/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

public enum CornerRadius {
    case circle, custom(CGFloat)
}

struct FLSizeConstants {
    static let action: CGFloat = 44
    static let actionTitle: CGFloat = 60
}

struct FLAppColor {
    
    static var bg : UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named:"bg", in: BundleManager.assets.bundle, compatibleWith: nil) ?? #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        } else {
            return #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        }
    }
    
    static var content : UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named:"content", in: BundleManager.assets.bundle, compatibleWith: nil) ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}
