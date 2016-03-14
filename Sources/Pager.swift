//
//  Pager.swift
//  AMCPodcastScraper
//
//  Created by Donovan Mueller on 3/7/16.
//  Copyright © 2016 Donovan Mueller. All rights reserved.
//

import HTTPClient


class Pager : SequenceType {
	typealias Generator = AnyGenerator<PagerReturn>
	
	let httpClient: Client
	var nextPagePath: String?
	var pages = [SermonPage]()
	
	init(client: Client, firstPagePath: String) {
		httpClient = client
		nextPagePath = firstPagePath
	}
	
	func generate() -> AnyGenerator<PagerReturn> {
		var index = 0
		
		return AnyGenerator {
			if self.nextPagePath == nil {
				if index < self.pages.count {
					index += 1
					return .Success(self.pages[index-1])
				}
				return nil
			}
			
			var nextPagePath = self.nextPagePath!
			if nextPagePath.characters.count > 0
				  && nextPagePath[nextPagePath.startIndex] != "/" {
				nextPagePath = "/\(nextPagePath)"
			}
			
			let response: Response
			do {
  			response = try self.httpClient.get(nextPagePath)
			} catch {
				return .Failure(.DownloadFailure(path: nextPagePath, error: error))
			}
			guard let body = response.body.buffer else {
				return .Failure(.EmptyResponseBody(path: nextPagePath))
			}
			let html: String
			do {
				html = try String(data: body)
			} catch {
				return .Failure(.Other(
					message: "Failed converting body data to string",
					path: nextPagePath, error: error))
			}
			
			let nextPagePathRange = html.rangeOfString(
      	"(?<=<a href=\")[^\"]+(?=\">[Pp]age *\\d+>></a>)",
				options: .RegularExpressionSearch)
			self.nextPagePath = nextPagePathRange != nil
				? html.substringWithRange(nextPagePathRange!) : nil
			
			let page = SermonPage(html: html)
			self.pages.append(page)
			return .Success(page)
		}
	}
}


enum PagerReturn {
	// Since generators can't throw errors, this is the next best thing.
	case Success(SermonPage)
	case Failure(PagerError)
}


enum PagerError : ErrorType {
	case DownloadFailure(path: String, error: ErrorType)
	case EmptyResponseBody(path: String)
	case Other(message: String, path: String, error: ErrorType)
}