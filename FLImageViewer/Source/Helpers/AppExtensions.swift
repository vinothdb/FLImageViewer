//
//  AppExtensions.swift
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
        return FLBundle?.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView
    }
}
