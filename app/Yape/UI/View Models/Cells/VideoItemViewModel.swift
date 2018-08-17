//
//  VideoItemViewModel.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol VideoItemViewModelProtocol: class {
    var title: String { get }
    var duration: String { get }
    var isLastInSection: Bool { get }
    
    func didStartHover()
    func didFinishHover()
    func didSelect()
    func didPressReveal()
}

final class VideoItemViewModel: VideoItemViewModelProtocol {
    typealias Dependencies = CommandsDispatcherProvider
    
    private let dependencies: Dependencies
    private let videoItem: VideoItem
    
    init(videoItem: VideoItem,
         dependencies: Dependencies = ServicesContainer.shared) {
        self.videoItem = videoItem
        self.dependencies = dependencies
    }
    
    // MARK: VideoItemViewModelProtocol
    
    var isLastInSection: Bool = false
    
    var title: String {
        return (self.videoItem.isPlaying ? "⏸ " : "▶️ ") + self.videoItem.title
    }
    
    var duration: String {
        guard let duration = videoItem.duration else {
            return ""
        }
        return String(format: "%02d:%02d", Int(duration) / 60, Int(duration) % 60)
    }
    
    func didStartHover() {
        let command: ExtensionCommand = .highlightVideo(videoId: self.videoItem.uid)
        self.dependencies.commandsDispatcher.send(command: command)
    }
    
    func didFinishHover() {
        self.dependencies.commandsDispatcher.send(command: .removeHighlight)
    }
    
    func didSelect() {
        let command: ExtensionCommand = .enablePiP(videoId: self.videoItem.uid)
        self.dependencies.commandsDispatcher.send(command: command)
    }
    
    func didPressReveal() {
        let command: ExtensionCommand = .scrollToVideo(videoId: self.videoItem.uid)
        self.dependencies.commandsDispatcher.send(command: command)
    }
}
