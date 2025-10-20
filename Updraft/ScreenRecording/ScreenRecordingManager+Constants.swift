//
//  ScreenRecordingManager.swift
//  Updraft
//
//  Created by Yanis Plumit on 15.09.2025.
//

import SwiftUI
import UIKit

extension ScreenRecordingManager {
    enum MaxScreenVideoDuration: Int, CaseIterable, Identifiable {
        case halfMinute = 30
        case oneMinute = 60
        case fiveMinutes = 300
        case tenMinutes = 600
        
        var id: Int { self.rawValue }
        var ls: String {
            switch self {
            case .halfMinute: return "30 sec"
            case .oneMinute: return "1 min"
            case .fiveMinutes: return "5 min"
            case .tenMinutes: return "10 min"
            }
        }
    }
    
    static let isScreenRecordingOnKey = "Updraft.screenRecording.isScreenRecordingOn"
    static let maxVideoDurationKey = "Updraft.screenRecording.maxVideoDuration"
}
