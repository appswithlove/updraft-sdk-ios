//
//  ScreenRecordingManager.swift
//  Updraft
//
//  Created by Yanis Plumit on 15.09.2025.
//

import SwiftUI

class ScreenRecordingManager: ObservableObject {
    static let shared = ScreenRecordingManager()
    private init() {}
    
    var isFeedbackScreensVisible = false
    
    @Published var isExportingVideo = false
    @Published var imageUrl: [ScreenRecorder.VideoItem: URL] = [:]
    
    @Published var isScreenRecordingOn: Bool? = {
        if UserDefaults.standard.object(forKey: ScreenRecordingManager.isScreenRecordingOnKey) == nil {
            return nil
        }
        return UserDefaults.standard.bool(forKey: ScreenRecordingManager.isScreenRecordingOnKey)
    }() {
        didSet {
            UserDefaults.standard.set(isScreenRecordingOn, forKey: ScreenRecordingManager.isScreenRecordingOnKey)
        }
    }
    
    @Published var maxVideoDuration: MaxScreenVideoDuration = {
        return MaxScreenVideoDuration(rawValue: UserDefaults.standard.integer(forKey: ScreenRecordingManager.maxVideoDurationKey)) ?? .fiveMinutes
    }() {
        didSet {
            UserDefaults.standard.set(maxVideoDuration.rawValue, forKey: ScreenRecordingManager.maxVideoDurationKey)
        }
    }
    
    var isScreenRecordingOnByDefault: Bool = false
    
    func initialise(isScreenRecordingOn: Bool = false) {
        isScreenRecordingOnByDefault = isScreenRecordingOn
        startIfNeed()
    }
    
    func startIfNeed() {
        if (isScreenRecordingOn ?? isScreenRecordingOnByDefault) && !isFeedbackScreensVisible {
            ScreenRecorder.shared.start(duration: maxVideoDuration.rawValue)
        }
    }
    
    func stop() {
        ScreenRecorder.shared.stop()
        imageUrl[.current] = ScreenRecorder.shared.videoImage(.current)
        imageUrl[.last] = ScreenRecorder.shared.videoImage(.last)
    }
    
    func exportVideo(_ item: ScreenRecorder.VideoItem, completion: @escaping (URL?) -> Void) {
        self.isExportingVideo = true
        ScreenRecorder.shared.exportVideo(item) { url in
            self.isExportingVideo = false
            completion(url)
        }
    }
    
    func delete(_ item: ScreenRecorder.VideoItem) {
        ScreenRecorder.shared.delete(item)
        imageUrl[item] = ScreenRecorder.shared.videoImage(item)
    }
}

