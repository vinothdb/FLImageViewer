
//
//  FLStoryboardHelper.swift
//  FLImageViewer
//
//  Created by Vinoth on 14/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

//let FLBundle: Bundle = {
//    return Bundle(for: FLImageViewer.self)
//}()

enum BundleManager {
    
    case forSource, forAssets, forResources
    
    var bundle : Bundle {
        let frameworkBundle = Bundle(for: FLImageViewer.self)
        switch self {
        case .forSource, .forResources:
            return frameworkBundle
        case .forAssets:
            guard let resourceUrl = frameworkBundle.resourceURL,
                let assetsBundle = Bundle(url: resourceUrl.appendingPathComponent(self.bundleName)) else {
                    return frameworkBundle
            }
            return assetsBundle
        }
    }
    
    var bundleName : String {
        switch self {
        case .forSource, .forResources:
            return "FLImageViewer.bundle"
        case .forAssets:
            return "FLImageViewerResources.bundle"
        }
    }
}

enum FLViewControllers {
    
    case ImageViewer
    
    private var storyboardName: String {
        switch self {
        case .ImageViewer:
            return "FLMainStoryboard"
        }
    }
    
    private var storyboard: UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: BundleManager.forSource.bundle)
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
