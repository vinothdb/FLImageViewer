
//
//  FLStoryboardHelper.swift
//  FLImageViewer
//
//  Created by Vinoth on 14/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

let FLBundle: Bundle = {
    return Bundle(for: FLImageViewer.self)
}()

enum FLViewControllers {
    
    case ImageViewer
    
    private var storyboardName: String {
        switch self {
        case .ImageViewer:
            return "FLMainStoryboard"
        }
    }
    
    private var storyboard: UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: FLBundle)
    }
    
    private var storyboardId: String {
        switch self {
        case .ImageViewer:
            return "FLViewerControllerStoryboardId"
        }
    }
    
    func instantiate<T: UIViewController>() -> T? {
        switch self {
        case .ImageViewer:
            return self.storyboard.instantiateViewController(withIdentifier: self.storyboardId) as? T
        }
    }
}
