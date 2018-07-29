//
//  VideoItemViewModel.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol VideoItemViewModelProtocol {
    var title: String { get }
    
    func didStartHover()
    func didFinishHover()
    func didSelect()
}

final class VideoItemViewModel: VideoItemViewModelProtocol {
    typealias Dependencies = CommandsDispatcherProvider
    
    private let dependencies: Dependencies
    private let videoItem: VideoItem

    let title: String
    
    init(videoItem: VideoItem,
         dependencies: Dependencies = ServicesContainer.shared) {
        self.videoItem = videoItem
        self.dependencies = dependencies
        self.title = videoItem.title
    }
    
    func didStartHover() {
        let command: ExtensionCommand = .toggleHighlight(videoId: self.videoItem.uid, highlight: true)
        self.dependencies.commandsDispatcher.send(command: command)
    }
    
    func didFinishHover() {
        let command: ExtensionCommand = .toggleHighlight(videoId: self.videoItem.uid, highlight: false)
        self.dependencies.commandsDispatcher.send(command: command)
    }
    
    func didSelect() {
        let command: ExtensionCommand = .enablePiP(videoId: self.videoItem.uid)
        self.dependencies.commandsDispatcher.send(command: command)
    }
}
