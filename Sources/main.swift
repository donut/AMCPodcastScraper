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


func doIt() {
	let pages: [SermonPage]
	do {
  	pages = try getPages("www.albanymennonite.org", path: "/sermons.html")
  } catch IPError.Unknown(let error) {
  	print("Failed creating HTTP client: \(error)")
		return
  } catch let PagerError.DownloadFailure(path, error) {
  	print("Failed downloading page [\(path)]: \(error)")
		return
  } catch let PagerError.EmptyResponseBody(path) {
  	print("Empty body returned from [\(path)].")
		return
  } catch {
  	print("Error: \(error)")
		return
	}
	
	let sermons = pages.reduce([], combine: +)
		.filter({ $0.fileUrl.characters.count > 0 })
		.map {[
			"title": $0.title,
			"date":  $0.date,
			"description": $0.description,
			"imgUrl": $0.imgUrl,
			"fileUrl": $0.fileUrl
  	]}
	
	let sermonsInJSON = JSON.from(sermons.map({ JSON.from($0.valuesMap(JSON.from)) }))
//	let filePath = try genFilePath("dumps")
	let filePath = "files.json"
	let exists = File.fileExistsAt(filePath)
	if exists.fileExists && !exists.isDirectory {
		do {
    	try File.removeItemAt(filePath)
		} catch {
			// `File.removeItemsAt()` first assumes the item is a directory and runs
			// `rmdir()` and if that fails then goes to `unlink()`. However, this
			// means that it throws every time it removes a file.
      if errno != ENOTDIR {
  			print("Failed removing old file [\(filePath)]: \(error)")
    		return
			}
		}
	}
	do {
  	try save(sermonsInJSON, to: filePath)
	} catch {
		print("Failed saving file [\(filePath)]: \(error)")
		return
	}
}


doIt()

// @todo: Us NSTimer (?) to check every so often
// @see http://stackoverflow.com/questions/24007650/selector-in-swift
//   for Selector alternative

