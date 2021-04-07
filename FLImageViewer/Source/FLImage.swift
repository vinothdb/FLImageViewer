//
//  FLImage.swift
//  FLImageViewer
//
//  Created by Deepika on 07/04/21.
//  Copyright © 2021 Vinoth. All rights reserved.
//

import UIKit

public class FLImage {
	
	let uniqueKey: String
	public let image: UIImage
	public var caption: String?
	
	init(image: UIImage) {
		self.image = image
		self.uniqueKey = String.random(length: 10)
	}
	
	static func fl_images(images:[UIImage]) -> [FLImage] {
		
		var fl_images: [FLImage] = []
		for image in images {
			fl_images.append(FLImage(image: image))
		}
		return fl_images
	}
	
	static func toUIImage(images:[FLImage]) -> [UIImage] {
		return images.map { $0.image }
	}
}
