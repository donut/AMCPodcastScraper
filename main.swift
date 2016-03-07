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

let page = SermonPage(html: html)

for sermon in page {
	print("###")
	print(sermon.title)
	print(sermon.date)
	print(sermon.speakerName)
	print(sermon.description)
	print(sermon.imgUrl)
	print(sermon.fileUrl)
	print("###")
}