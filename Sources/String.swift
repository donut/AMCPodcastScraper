//
//  String.swift
//  AMCPodcastScraper
//
//  Created by Donovan Mueller on 3/7/16.
//  Copyright © 2016 Donovan Mueller. All rights reserved.
//

import Foundation

extension String {
	
	mutating func reduceWhiteSpace() {
		// Reduces white space down to single spaces.
		let maybeWhiteSpaceRange = self.rangeOfString(
			"\\s{2,}|[\t\n\r]{1,}", options: .RegularExpressionSearch)
		
		if let whiteSpaceRange = maybeWhiteSpaceRange {
			self.replaceRange(whiteSpaceRange, with: " ")
			self.reduceWhiteSpace()
		}
	}
	
	mutating func stripHtmlTags() {
		// Strip all HTML tags, one at a time.
		let maybeTagRange = self.rangeOfString(
			"<[^>]*>", options: .RegularExpressionSearch)
		
		if let tagRange = maybeTagRange {
			self.replaceRange(tagRange, with: "")
			self.stripHtmlTags()
		}
	}
}