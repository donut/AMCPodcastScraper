//
//  main.swift
//  AMCPodcastScraper
//
//  Created by Donovan Mueller on 3/2/16.
//  Copyright © 2016 Donovan Mueller. All rights reserved.
//

import Foundation
import HTTPClient

let client   = try Client(host: "www.albanymennonite.org", port: 80)
let response = try client.get("/sermons.html")

let body = response.body.buffer
let html = try String(data: body!)

let openDivRange = html.rangeOfString(
	"<div class=\"sermon1\">", range: html.characters.indices)
let closeDivRange = html.rangeOfString("</div>",
  range: openDivRange!.startIndex.advancedBy(1)..<html.endIndex)
let sermonRange =
		openDivRange!.endIndex.advancedBy(1)..<closeDivRange!.startIndex

let sermon = html.substringWithRange(sermonRange)
print(sermon)

let dateRange = html.rangeOfString(
	"(?<=<!--DATE HERE-->(<em>))([\\w\\d, ]+)(?=</em>)",
  options: .RegularExpressionSearch, range: sermonRange)
let date = html.substringWithRange(dateRange!)
print(date)

let imgUrlRange = html.rangeOfString(
	"(?<=src=\")[^\"]+(?=\")",
	options: .RegularExpressionSearch, range: sermonRange)
let imgUrl = html.substringWithRange(imgUrlRange!)
print(imgUrl)

let speakerRange = html.rangeOfString(
	"(?<=<!--SPEAKER HERE-->(<b>))([\\w\\d, ]+)(?=</b>)",
  options: .RegularExpressionSearch, range: sermonRange)
let speaker = html.substringWithRange(speakerRange!)
print(speaker)

let titleRange = html.rangeOfString(
	"<h3[^>]*>.+</h3>",
  options: .RegularExpressionSearch, range: sermonRange)
var title = html.substringWithRange(titleRange!)
title.replace("<br>", with: " ")

print(title)

func cleanupWhiteSpaceIn(aString: String) -> String {
	let maybeWhiteSpaceRange = aString.rangeOfString(
		"\\s{2,}", options: .RegularExpressionSearch)
	if let whiteSpaceRange = maybeWhiteSpaceRange {
  	var string = aString
		string.replaceRange(whiteSpaceRange, with: " ")
		return cleanupWhiteSpaceIn(string)
	}
	return aString.trim()
}

func removeFirstHTMLTag(aString: String) -> String {
	var string = aString
	let maybeTagRange = string.rangeOfString(
		"<[^>]*>", options: .RegularExpressionSearch)
	
	if let tagRange = maybeTagRange {
  	string.replaceRange(tagRange, with: "")
	}
	
	return string
}

func stripHTMLTags(string: String) -> String {
	let stripped = removeFirstHTMLTag(string)
	return stripped == string ? string : stripHTMLTags(stripped)
}

print(cleanupWhiteSpaceIn(stripHTMLTags(title)))


let fileUrlRange = html.rangeOfString(
	"(?<=href=\")[^\"]+\\.mp3(?=\")",
  options: .RegularExpressionSearch, range: sermonRange)
let fileUrl = html.substringWithRange(fileUrlRange!)
print(fileUrl)

let descRange = html.rangeOfString(
	"(?<=<em><!--SCRIPTURE HERE-->)([^<]+)(?=</em>)",
  options: .RegularExpressionSearch, range: sermonRange)
let desc = html.substringWithRange(descRange!)
print(desc)