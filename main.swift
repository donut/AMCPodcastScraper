//
//  main.swift
//  AMCPodcastScraper
//
//  Created by Donovan Mueller on 3/2/16.
//  Copyright © 2016 Donovan Mueller. All rights reserved.
//

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

print(JSON.from(sermons.map({ JSON.from($0.mapValues(JSON.from)) })))

// @todo: Us NSTimer (?) to check every so often
// @see http://stackoverflow.com/questions/24007650/selector-in-swift
//   for Selector alternative