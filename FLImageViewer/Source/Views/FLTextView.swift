//
//  FLTextView.swift
//  FLImageViewer
//
//  Created by Deepika on 05/04/21.
//  Copyright © 2021 Vinoth. All rights reserved.
//

import UIKit

struct FLTextViewConfiguration {
	var bgColor: UIColor = .white
	var textColor: UIColor = .black
	var placeholderTextColor: UIColor = .gray
	var borderColor: UIColor = .gray
	var cursorColor: UIColor = .black
	var cornerRadius: CGFloat = 0
	var borderWidth: CGFloat = 0
	var font: UIFont = UIFont()
	var noOfLines: Int = 4
}

class FLTextView: UITextView {

	lazy var heightContraint: NSLayoutConstraint = {
			let constraint = self.heightAnchor.constraint(equalToConstant: width)
			constraint.isActive = true
			return constraint
	}()
	
	lazy var widthContraint: NSLayoutConstraint = {
		let constraint = self.widthAnchor.constraint(equalToConstant: width)
		constraint.isActive = true
		return constraint
	}()
	
	var width: CGFloat = UIScreen.main.bounds.width {
		didSet {
			widthContraint.constant = width
		}
	}
	var height: CGFloat = 50 {
		didSet {
			heightContraint.constant = height
		}
	}
//	var isOverSized: Bool = false {
//		didSet {
//			self.isScrollEnabled = isOverSized
//			heightContraint.constant = min(maxHeight, max(minHeight, contentSize.height))
//			UIView.animate(withDuration: 0.3) {
//				self.layoutIfNeeded()
//			}
//		}
//	}
//
//	let maxHeight: CGFloat = 100
//	let minHeight: CGFloat = 50
//
//	var placeHolderText: String?
//	var config: FLTextViewConfiguration!

}

extension FLTextView: UITextViewDelegate {
	
//	func textViewDidChange(_ textView: UITextView) {
//		isOverSized = contentSize.height >= maxHeight
////		if text.isEmpty, let placeHolder = placeHolderText {
////			text = placeHolder
////			textColor =
////		}
//	}
}

extension FLTextView {
	static func create(withText text: String? = nil,
					   placeHolder: String? = "Add caption",
					   config: FLTextViewConfiguration = FLTextViewConfiguration(),
					   width: CGFloat = 300) -> FLTextView {
		let textView = FLTextView()
		textView.width = width
		textView.height = 50
		textView.isScrollEnabled = false
		textView.text = "TRYING something"
		textView.translatesAutoresizingMaskIntoConstraints = false
		return textView
	}
}
