//
//  main.swift
//  AMCPodcastScraper
//
//  Created by Donovan Mueller on 3/2/16.
//  Copyright © 2016 Donovan Mueller. All rights reserved.
//

import Foundation
import HTTPClient

print("Making request...")

let client   = try Client(host: "www.albanymennonite.org", port: 80)
let response = try client.get("/sermons.html")

print("Response:")
if let body = response.body.buffer, let html: String? = try String(data: body) {
	print(html)
} else {
	print("Failed retreiving body")
}

