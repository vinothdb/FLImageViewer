//
//  ViewerTableDelegate.swift
//  FLImageViewer
//
//  Created by Vinoth on 14/02/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

@available(iOS 13,*)
typealias FLImageDataSourceSnapShot = NSDiffableDataSourceSnapshot<String, String>

@available(iOS 13, *)
extension FLImageDataSourceSnapShot {
    
    private var sectionTitle: String { return "ImagesViewerDefaultSection" }
    
    mutating func appendImages(imageKeys: [String]) {
        self.appendSections([self.sectionTitle])
        self.appendItems(imageKeys, toSection: self.sectionTitle)
    }
}

@available(iOS 13, *)
class FLImageDataSource : UITableViewDiffableDataSource<String, String> {
    
    func apply(images: [FLImage]) {
        
        let keys:[String] = images.map { $0.uniqueKey }
        
        var snapshot = FLImageDataSourceSnapShot()
        snapshot.appendImages(imageKeys: keys)
        
        self.apply(snapshot, animatingDifferences: true)
    }
}
