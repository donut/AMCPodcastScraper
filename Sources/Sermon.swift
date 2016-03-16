//
//  Sermon.swift
//  AMCPodcastScraper
//
//  Created by Donovan Mueller on 3/7/16.
//  Copyright © 2016 Donovan Mueller. All rights reserved.
//

import Foundation


class Sermon {
	let date: String
	let description: String
	let fileUrl: String
	let imgUrl: String
	let speakerName: String
	let title: String
	
	init(html: String) {
		date = extractDateFrom(html) ?? "January 1, 1970"
		description = extractDescFrom(html) ?? ""
		fileUrl = exractFileUrlFrom(html) ?? ""
		imgUrl = extractImgUrlFrom(html) ?? ""
		speakerName = extractSpeakerNameFrom(html) ?? "[Anonymous]"
		title = extractTitleFrom(html) ?? "[Untitled]"
	}
}


private func extract(pattern: String, from: String) -> String? {
  let range = from.rangeOfString(
  	pattern, options: .RegularExpressionSearch)
	return range != nil ? from.substringWithRange(range!) : nil
}


private func extractDateFrom(html: String) -> String? {
	return extract("(?<=<!--DATE HERE-->(<em>))([\\w\\d, ]+)(?=</em>)",
	               from: html)
}

private func extractDescFrom(html: String) -> String? {
	return extract("(?<=<em><!--SCRIPTURE HERE-->)([^<]+)(?=</em>)",
	               from: html)
}

private func exractFileUrlFrom(html: String) -> String? {
	return extract("(?<=href=\")[^\"]+\\.mp3(?=\")", from: html)
}

private func extractImgUrlFrom(html: String) -> String? {
	return extract("(?<=src=\")[^\"]+(?=\")", from: html)
}

private func extractSpeakerNameFrom(html: String) -> String? {
	return extract("(?<=<!--SPEAKER HERE-->(<b>))([\\w\\d, ]+)(?=</b>)",
	               from: html)
}

private func extractTitleFrom(html: String) -> String? {
	let title = extract("<h3[^>]*>.+</h3>", from: html)
	return title?
		.replacedAll("<br>", with: " ")
		.replacedAll("<p>", with: " ")
		.replacedAll("</p>", with: " ")
		.reducedWhiteSpace()
		.strippedHTMLTags()
		.trim()
}