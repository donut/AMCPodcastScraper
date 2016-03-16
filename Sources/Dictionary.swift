//
//  Dictionary.swift
//  AMCPodcastScraper
//
//  Created by Donovan Mueller on 3/9/16.
//  Copyright © 2016 Donovan Mueller. All rights reserved.
//

import Foundation

extension Dictionary {
	
	/// Map over the values of a dictionary.
	///
	/// - note:
	///		Adapted from [this StackOverflow answer](http://stackoverflow.com/a/29460871/134014).
	///
	/// - parameters:
	///		+ transform: The function to use to transform the values.
	/// - returns:
	///		New dictionary with the values transformed.
	
	func valuesMap<T>(transform: Value->T) -> Dictionary<Key,T> {
		var dict = [Key:T]()
		for (key, value) in zip(self.keys, self.values.map(transform)) {
			dict[key] = value
		}
		return dict
	}
}