
import File
import Foundation
import HTTPClient
import JSON

func getPages(from: String, path: String) throws -> [SermonPage] {
	let client = try Client(host: from, port: 80)
  let pager = Pager(client: client, firstPagePath: path)
	
	var pages = [SermonPage]()
	for page in pager {
		switch (page) {
    	case let .Success(page):
  			pages.append(page)
    	case let .Failure(error):
				throw error
    }
	}
	
	return pages
}


/// Generate the full file path with date.
func genFilePath(prefix: String?) throws -> String {
	let dir: String
	if prefix == nil || prefix!.characters.count == 0
		  || prefix![prefix!.startIndex] != "/" {
		let workingDir = try File.workingDirectory()
		dir = prefix != nil && prefix!.characters.count > 0
			? "\(workingDir)/\(prefix)" : workingDir
	} else {
		dir = prefix!
	}
	
  let dateComponents: NSCalendarUnit = [
  	.Year, .Month, .Day, .Hour, .Minute, .Second
  ]

  let filename: String
  // On Linux, this line returns an optional, but within Xcode it's not an
  // optional. Don't know what that's about.
  let maybeNow: NSDateComponents? =
  	NSCalendar.currentCalendar().components(dateComponents, fromDate: NSDate())
  if let now = maybeNow {
  	// String(format:) is not yet implemented on Linux, but NSString(format:)
		// is.
    filename = String(NSString(
  		format: "feed.%04d-%02d-%02d@%02d-%02d.json",
      now.year, now.month, now.day, now.hour, now.minute))
  } else {
  	filename = "feed.unknown_date.json"
  }
	
	return "\(dir)/\(filename)"
}


func save(json: JSON, to: String) throws {
  let file = try File(path: to, mode: .CreateWrite)
  try file.write(Data(String(json)))
  file.close()
}
