//
//  Logger.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 21.08.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

struct Logger {
	
	//As programmer, I want to log from code with a logLevel,
	//As user, I want to be able to set different logLevel from the SDK
	//- Speficying debug, show warning and error. - Warning show error etc. OptionSet could/should be used?
	//- Show function name, line number, class name (typeOf works ?)
	//Should system log be used ? os_log ? or simply print?
	//Debug, warning and error is needed. Is verbose too much ?
	
	enum LogLevel {
		case verbose, debug, warning, error
	}
	
	init(settings: Settings) {
		self.settings = settings
	}
	
	var logLevel: LogLevel = .warning
	var settings: Settings
	
	func log(_ items: Any..., level: LogLevel) {
		switch level {
		case :
			<#code#>
		default:
			<#code#>
		}
	}
}
