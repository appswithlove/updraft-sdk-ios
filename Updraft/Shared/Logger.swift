//
//  Logger.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 21.08.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

/// Log levels
///
/// - debug: Debug level
/// - Info: Info level
/// - `warning`: Warning level
/// - error: Error level
/// - none: No logs
@objc public enum LogLevel: Int {
	case debug = 0, info, warning, error, none
	
	var textPrefix: String {
		switch self {
		case .debug:
			return "🔨 DEBUG"
		case .info:
			return "💡 INFO"
		case .warning:
			return "⚠️ WARNING"
		case .error:
			return "❗️ERROR"
		case .none:
			return ""
		}
	}
}

public struct Logger {
	
	static var logLevel: LogLevel = .warning
	
	static func log(_ items: Any..., level: LogLevel, function: String = #function, line: Int = #line, filePath: String = #file) {
		if level.rawValue >= logLevel.rawValue {
			let message = buildLogMessage(logText: "\(items[0])", level: level, function: function, line: line, filePath: filePath)
			Swift.print(message, separator: " ", terminator: "\n")
		}
	}
	
	private static func buildLogMessage(logText: String, level: LogLevel, function: String, line: Int, filePath: String) -> String {
		var message = "--UPDRAFT--"
		
		message.append(" " + level.textPrefix)
		
		if level == .warning || level == .error {
			let fileName = URL(fileURLWithPath: filePath).lastPathComponent
			message.append(" - \(fileName) \(function):\(line)")
		}
		
		message.append(" " + "-" + " " + logText )
		
		return message
	}
}
