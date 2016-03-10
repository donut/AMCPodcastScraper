//
//  Dictionary.swift
//  AMCPodcastScraper
//
//  Created by Donovan Mueller on 3/9/16.
//  Copyright © 2016 Donovan Mueller. All rights reserved.
//

import Foundation

extension Dictionary {
	
	func valuesMap<T>(transform: Value->T) -> Dictionary<Key,T> {
		// Adapted from http://stackoverflow.com/a/29460871/134014
		var dict = [Key:T]()
		for (key, value) in zip(self.keys, self.values.map(transform)) {
			dict[key] = value
		}
		return dict
	}
}