//
//  Test.swift
//  AMCPodcastScraper
//
//  Created by Donovan Mueller on 3/4/16.
//  Copyright © 2016 Donovan Mueller. All rights reserved.
//

import Foundation


class SermonPage : SequenceType {
	typealias Generator = AnyGenerator<Sermon>
	
	let html: String
	var sermons = [Sermon]()
	var lastParseIndex: String.Index
	var fullyParsed = false
	
	init(html: String) {
		self.html = html
		lastParseIndex = html.startIndex
	}
	
	func generate() -> AnyGenerator<Sermon> {
		var index = 0
		
		return AnyGenerator {
			if self.fullyParsed {
				// No need to reparse the HTML.
				if index < self.sermons.count {
					index += 1
					return self.sermons[index-1]
				}
				return nil
			}
			
      let openDivRange = self.html.rangeOfString("<div class=\"sermon1\">",
				range: self.lastParseIndex..<self.html.endIndex)
			if openDivRange == nil {
				self.fullyParsed = true
				return nil
			}
			
      let closeDivRange = self.html.rangeOfString(
				"</div>",
				range: openDivRange!.startIndex.advancedBy(1)..<self.html.endIndex
			) ?? openDivRange!.startIndex.advancedBy(1)..<self.html.endIndex
			
      let sermonRange =
    		openDivRange!.endIndex.advancedBy(1)..<closeDivRange.startIndex
			
			let sermon = Sermon(html: self.html.substringWithRange(sermonRange))
			
			self.lastParseIndex = closeDivRange.endIndex
			self.sermons.append(sermon)

			return sermon
		}
	}
}