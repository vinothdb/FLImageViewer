//
//  FLAppExtensions.swift
//  FLImageViewer
//
//  Created by Vinoth on 14/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

extension String {
    
    static func random(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
extension UIView {
    func viewFromXib() -> UIView? {
        return BundleManager.source.bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView
    }
}

extension UIImage {
    
    class func systemImage(_ name: String) -> UIImage? {    
        guard #available(iOS 13, *) else { return nil }
        
        return UIImage(systemName: name)
    }
    
    func resizedImage(toMax width:CGFloat, height:CGFloat) -> UIImage? {
        let oldWidth = self.size.width
        let oldHeight = self.size.height
            
        let scaleFactor = (oldWidth > oldHeight) ? width/oldWidth : height/oldHeight

        let newSize = CGSize(width: oldWidth*scaleFactor, height: oldHeight*scaleFactor)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UITableView {
    
    func hasIndexPath(_ indexPath: IndexPath) -> Bool {
        return self.numberOfSections > indexPath.section && self.numberOfRows(inSection: indexPath.section) > indexPath.row
    }
}
