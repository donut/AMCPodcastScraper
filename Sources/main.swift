//
//  main.swift
//  AMCPodcastScraper
//
//  Created by Donovan Mueller on 3/2/16.
//  Copyright © 2016 Donovan Mueller. All rights reserved.
//

import File
import Foundation
import HTTPClient
import JSON

let client = try Client(host: "www.albanymennonite.org", port: 80)
let pager = Pager(client: client, firstPagePath: "/sermons.html")

var sermons = [[String:String]]()
for pagerReturn in pager {
	let page: SermonPage
	
	switch pagerReturn {
  	case let .Success(_page):
			page = _page
  	case let .Failure(message, path, error):
			print("\(message); path: \(path); error: \(error)")
			continue
	}
	
  for sermon in page {
  	if sermon.fileUrl.characters.count == 0 {
			print("Incomplete sermon: \(sermon)")
    	continue
  	}
		sermons.append([
			"title": sermon.title,
			"date":  sermon.date,
			"description": sermon.description,
			"imgUrl": sermon.imgUrl,
			"fileUrl": sermon.fileUrl
		])
  }
}

let sermonsInJson = JSON.from(sermons.map({ JSON.from($0.valuesMap(JSON.from)) }))
debugPrint(sermonsInJson)

let dateComponents: NSCalendarUnit = [
	.Year, .Month, .Day, .Hour, .Minute, .Second
]

let filename: String
// On Linux, this line returns an optional, but within Xcode it's not an
// optional. Don't know what that's about.
let maybeNow: NSDateComponents? =
	NSCalendar.currentCalendar().components(dateComponents, fromDate: NSDate())
if let now = maybeNow {
	// String(format:) is not yet implemented on Linux, but NSString(format:) is.
  filename = String(NSString(
		format: "feed.%04d-%02d-%02d@%02d-%02d.json",
    now.year, now.month, now.day, now.hour, now.minute))
} else {
	filename = "feed.unknown_date.json"
}
debugPrint(filename)

var file = try File(path: filename, mode: .CreateWrite)
try file.write(Data(String(sermonsInJson)))
file.close()
debugPrint(try File.workingDirectory())


// @todo: Us NSTimer (?) to check every so often
// @see http://stackoverflow.com/questions/24007650/selector-in-swift
//   for Selector alternative