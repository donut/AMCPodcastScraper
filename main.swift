//
//  main.swift
//  AMCPodcastScraper
//
//  Created by Donovan Mueller on 3/2/16.
//  Copyright © 2016 Donovan Mueller. All rights reserved.
//

import HTTPClient

let client = try Client(host: "www.albanymennonite.org", port: 80)
let pager = Pager(client: client, firstPagePath: "/sermons.html")

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
  	print("###")
  	print(sermon.title)
  	print(sermon.date)
  	print(sermon.speakerName)
  	print(sermon.description)
  	print(sermon.imgUrl)
  	print(sermon.fileUrl)
  	print("###")
  }
}

// @todo: Us NSTimer (?) to check every so often
// @see http://stackoverflow.com/questions/24007650/selector-in-swift
//   for Selector alternative