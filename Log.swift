//
//  Log.swift
//  BeatBoxers
//
//  Created by Andrew Karell on 23/04/15.
//  Copyright (c) 2015 BeatBoxers. All rights reserved.
//

import Foundation

struct LogLevels {
	static let VERBOSE = "v"
	static let DEBUG = "d"
	static let INFO = "i"
	static let WARN = "w"
	static let ERROR = "e"
	static let ASSERT = "a"
}

class Log {
	init(_ logTag: String, _ message: String) {
		Log.i(logTag, message)
	}
	
	static func v(logTag: String, _ message: String) {
		log(LogLevels.VERBOSE, logTag, message)
	}
	
	static func d(logTag: String, _ message: String) {
		log(LogLevels.DEBUG, logTag, message)
	}
	
	static func i(logTag: String, _ message: String) {
		log(LogLevels.INFO, logTag, message)
	}
	
	static func w(logTag: String, _ message: String) {
		log(LogLevels.WARN, logTag, message)
	}
	
	static func e(logTag: String, _ message: String) {
		log(LogLevels.ERROR, logTag, message)
	}
	
	static func a(logTag: String, _ message: String) {
		log(LogLevels.ASSERT, logTag, message)
	}
	
	static private func log(level: String, _ tag: String, _ message: String) {
		println(level+") "+tag+": "+message)
	}
}