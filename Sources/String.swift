//
//  String.swift
//  AMCPodcastScraper
//
//  Created by Donovan Mueller on 3/7/16.
//  Copyright © 2016 Donovan Mueller. All rights reserved.
//

import Foundation

extension String {
	
	/// Immutable version of `String.replace()`
	///
	/// - parameters:
	///		- of: What to replace all occurrences of.
	///		- with: What to replace `of` with.
	/// - returns:
	///		A new string with all instances of `of` replaced with `with`.
	func replacedAll(of: String, with: String) -> String {
		var string = self
		string.replace(of, with: with)
		return string
	}
	
	/// Reduces all consecutive white space characters to single spaces.
	/// 
	/// For example, the string "`Hello, \n\t\t world!   It's a\nme\tMario!`"
	/// would get changed to "`Hello, world! It's a me Mario!`".
	func reducedWhiteSpace() -> String {
		// Reduces white space down to single spaces.
		let maybeWhiteSpaceRange = self.rangeOfString(
			"\\s{2,}|[\t\n\r]{1,}", options: .RegularExpressionSearch)
		
		if let whiteSpaceRange = maybeWhiteSpaceRange {
			var new = self
			new.replaceRange(whiteSpaceRange, with: " ")
			return new.reducedWhiteSpace()
		}
		
		return self
	}
	
	/// Strips all HTML tags from the string.
	func strippedHTMLTags() -> String{
		let maybeTagRange = self.rangeOfString(
			"<[^>]*>", options: .RegularExpressionSearch)
		
		if let tagRange = maybeTagRange {
			var new = self
			new.replaceRange(tagRange, with: "")
			return new.strippedHTMLTags()
		}
		
		return self
	}
}