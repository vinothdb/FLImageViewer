//
//  FLTextView.swift
//  FLImageViewer
//
//  Created by Deepika on 05/04/21.
//  Copyright © 2021 Vinoth. All rights reserved.
//

import UIKit

public struct FLTextViewConfiguration {
	
	let bgColor: UIColor
	let textColor: UIColor
	let placeholderTextColor: UIColor
	let cursorColor: UIColor
	let font: UIFont
	let noOfLines: Int
	
	public init(bgColor: UIColor = .white,
				textColor: UIColor = .black,
				placeholderTextColor: UIColor = .gray,
				cursorColor: UIColor = .black,
				font: UIFont = .systemFont(ofSize: 16),
				noOfLines: Int = 3) {
		self.bgColor = bgColor
		self.textColor = textColor
		self.placeholderTextColor = placeholderTextColor
		self.cursorColor = cursorColor
		self.font = font
		self.noOfLines = noOfLines
	}
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

	lazy var placeholderLabel: UILabel = UILabel()
	
	var maxNoOfLines: Int = 3
	var didFlashScrollIndicators = false
	weak var textViewDelegate: FLTextViewDelegate?
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.placeholderLabel.isHidden = self.shouldHidePlaceHolder()
		if !self.placeholderLabel.isHidden {
			UIView.performWithoutAnimation({
				self.placeholderLabel.frame = self.placeHolderRectThatFits(bounds: self.bounds)
				self.sendSubviewToBack(self.placeholderLabel)
			})
		}
	}
	
	private func setupView() {
		delegate = self
		addPlaceholderLabel()
		self.scrollsToTop = false
		self.isDirectionalLockEnabled = true
		self.contentInset = UIEdgeInsets(top: 0, left: 0.1, bottom: 0, right: 0.1)
		font = .systemFont(ofSize: 20)
	}
	
	func addPlaceholderLabel() {
		self.addSubview(placeholderLabel)
	}
	
	func shouldHidePlaceHolder() -> Bool {
		return !self.text.isEmpty
	}
	
	func placeHolderRectThatFits(bounds: CGRect) -> CGRect {
		
		// default lineFragment padding 5
		let padding = self.textContainer.lineFragmentPadding
		
		var rect = CGRect.zero
		
		rect.size.height = self.placeholderLabel.sizeThatFits(bounds.size).height
		rect.size.width = self.textContainer.size.width - (padding * 2)
		
		rect.origin = bounds.inset(by: self.textContainerInset).origin
		rect.origin.x += 3
		
		return rect
	}
	
	func configure(withPlaceholder placeholder: String? = "Add Caption...",
				   _ config: FLTextViewConfiguration) {
		self.backgroundColor = config.bgColor
		self.textColor = config.textColor
		self.placeholderLabel.textColor = config.placeholderTextColor
		self.tintColor = config.cursorColor
		self.font = config.font
		self.placeholderLabel.font = config.font
		self.maxNoOfLines = config.noOfLines
		self.placeholderLabel.text = placeholder
	}
}

extension FLTextView: UITextViewDelegate {
	
	func shouldShowPlaceholder(_ shouldShow: Bool) {
		placeholderLabel.isHidden = !shouldShow
	}
	
	func textViewDidChange(_ textView: UITextView) {
		textViewDelegate?.didChangeCaption(self.text)
		shouldShowPlaceholder(text.isEmpty)
	}
}

// MARK: - Custom Actions
extension FLTextView {
	
	var expectedHeight: CGFloat {
		let noOfLine = numberOfLine()
		let shouldExpand = noOfLine < self.maxNoOfLines + 1
		isScrollEnabled = !shouldExpand
		flashScrollIndicatorsIfNeeded()
		let size = shouldExpand ? super.intrinsicContentSize : bounds.size
		return size.height
	}
	
	func sizeFit(width: CGFloat) -> CGSize {
		let fixedWidth = width
		let newSize = sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
		return CGSize(width: fixedWidth, height: newSize.height)
	}
	
	func numberOfLine() -> Int {
		let size = self.sizeFit(width: self.bounds.width)
		let numLines = Int(size.height / (self.font?.lineHeight ?? 1.0))
		return numLines
	}
	
	func fontLineHeight() -> CGFloat {
		return self.font?.lineHeight ?? 18
	}
	
	func scrollToBottom(animated: Bool) {
		
		guard let selectedTextRange = self.selectedTextRange else {
			return
		}
		
		var rect = self.caretRect(for: selectedTextRange.end)
		
		rect.size.height += self.textContainerInset.bottom
		
		if animated {
			self.scrollRectToVisible(rect, animated: animated)
		} else {
			UIView.performWithoutAnimation({
				self.scrollRectToVisible(rect, animated: false)
			})
		}
	}
	
	func flashScrollIndicatorsIfNeeded() {
		guard numberOfLine() == maxNoOfLines + 1 else { return }
		super.flashScrollIndicators()
	}
}

extension FLTextView {

	static func create(withText text: String? = nil,
					   placeHolder: String? = "Add caption",
					   config: FLTextViewConfiguration = FLTextViewConfiguration()) -> FLTextView {
		let textView = FLTextView()
		textView.isScrollEnabled = false
		textView.placeholderLabel.text = placeHolder
		textView.placeholderLabel.isHidden = false
		textView.translatesAutoresizingMaskIntoConstraints = false
		return textView
	}
}
