//
//  ScreenRecordingView.swift
//  Updraft
//
//  Created by Yanis Plumit on 18.10.2025.
//  Copyright © 2025 Apps with love AG. All rights reserved.
//

import SwiftUI

extension ScreenRecordingView {
    enum ModalScreenLinks: Identifiable {
        case video(url: URL)

        var id: String {
            switch self {
            case .video(let url): return "url_\(url)"
            }
        }
    }
}

struct ScreenRecordingView: View {
    @ObservedObject private var screenRecorder = ScreenRecordingManager.shared
    let didSelectVideoForExport: (URL) -> Void
    
    @State private var selectedVideo: ScreenRecorder.VideoItem?
    @State private var modalScreenLink: ModalScreenLinks?
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 16) {
                    Toggle(
                        "updraft_screen_recording".localized,
                        isOn: Binding(
                            get: {
                                if let userValue = screenRecorder.isScreenRecordingOn {
                                    return userValue
                                } else {
                                    return screenRecorder.isScreenRecordingOnByDefault
                                }
                            },
                            set: { newValue in
                                screenRecorder.isScreenRecordingOn = newValue
                            }
                        )
                    )
                    
                    Picker("", selection: $screenRecorder.maxVideoDuration) {
                        ForEach(ScreenRecordingManager.MaxScreenVideoDuration.allCases) { videoDuration in
                            Text(videoDuration.ls)
                                .tag(videoDuration)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                .background {
                    Color(UIColor.secondarySystemBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .foregroundColor(Color(UIColor.label))
                
                HStack {
                    let cells: [ScreenRecorder.VideoItem] = [.last, .current]
                    ForEach(0..<cells.count, id: \.self) { i in
                        let item = cells[i]
                        if let imageUrl = screenRecorder.imageUrl[item] {
                            videoCell(
                                imageUrl: imageUrl,
                                isSelected: selectedVideo == item,
                                loadVideoAction: {
                                    screenRecorder.exportVideo(item) { url in
                                        guard let url else { return }
                                        self.modalScreenLink = .video(url: url)
                                    }
                                },
                                deleteAction: {
                                    screenRecorder.delete(item)
                                    selectedVideo = nil
                                },
                                shareAction: {
                                    screenRecorder.exportVideo(item) { url in
                                        guard let url else { return }
                                        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                        UIViewController.topMostViewController()?.present(activityVC, animated: true)
                                    }
                                },
                                selectAction: {
                                    selectedVideo = item
                                }
                            )
                        } else {
                            Color.clear
                        }
                    }
                }
                .padding(.vertical)
                
                HStack {
                    Spacer()
                    Button(action: {
                        guard let selectedVideo = self.selectedVideo else { return }
                        screenRecorder.exportVideo(selectedVideo) { url in
                            guard let url else { return }
                            didSelectVideoForExport(url)
                        }
                    }, label: {
                        Text("updraft_feedback_button_next".localized)
                            .foregroundColor(Color(selectedVideo == nil ? UIColor.greyish : UIColor.macaroniAndCheese))
                            .font(Font.custom(UIFont.creteRegular, size: 16))
                            .underline()
                    })
                    .disabled(selectedVideo == nil)
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color(.spaceBlack).ignoresSafeArea())
        .fullScreenCover(item: $modalScreenLink, content: { link in
            switch link {
            case .video(let url):
                VideoFullscreenView(url: url)
            }
        })
        .foregroundColor(.white)
    }
    
    private func videoCell(imageUrl: URL,
                           isSelected: Bool = false,
                           loadVideoAction: @escaping () -> Void,
                           deleteAction: @escaping () -> Void,
                           shareAction: @escaping () -> Void,
                           selectAction: @escaping () -> Void) -> some View {
        VStack {
            ZStack {
                if let uiImage = UIImage(contentsOfFile: imageUrl.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                
                HStack(spacing: 16) {
                    Button(action: {
                        loadVideoAction()
                    }, label: {
                        Image(systemName: "play")
                    })
                    
                    Button(action: {
                        shareAction()
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                    })
                    
                    Button(action: {
                        deleteAction()
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
                .padding()
                .background {
                    Color(UIColor.black.withAlphaComponent(0.7))
                        .clipShape(Capsule())
                }
            }
            .disabled(screenRecorder.isExportingVideo)
            .overlay {
                if screenRecorder.isExportingVideo {
                    ProgressView()
                        .tint(Color(UIColor.macaroniAndCheese))
                }
            }
            
            Button(action: {
                selectAction()
            }, label: {
                ZStack {
                    Circle()
                        .stroke(Color(.greyish), lineWidth: 2)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(.macaroniAndCheese))
                            .transition(.scale)
                    }
                }
                .frame(width: 24, height: 24)
                .padding()
            })
        }
    }
}

#Preview {
    ScreenRecordingView(
        didSelectVideoForExport: { _ in }
    )
    .task {
        ScreenRecordingManager.shared.imageUrl[.current] = URL(string: "https://example.com/image.png")
        ScreenRecordingManager.shared.imageUrl[.last] = URL(string: "https://example.com/image.png")
    }
}

