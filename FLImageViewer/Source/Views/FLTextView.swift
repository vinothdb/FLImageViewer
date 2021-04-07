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

protocol FLTextViewDelegate: AnyObject {
	func didChangeCaption(_ caption: String)
}

class FLTextView: UITextView {

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		setupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}
	
	private func setupView() {
		delegate = self
	}
	
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
	
	weak var textViewDelegate: FLTextViewDelegate?
}

extension FLTextView: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		textViewDelegate?.didChangeCaption(self.text)
	}
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
