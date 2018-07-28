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
    typealias Dependencies = APIServiceProvider
    
    private let dependencies: Dependencies
    private let videoItem: VideoItem

    let title: String
    
    init(videoItem: VideoItem,
         dependencies: Dependencies = ServicesContainer.shared) {
        self.videoItem = videoItem
        self.dependencies = dependencies
        self.title = videoItem.title
    }
    
    private var hoverToken: Cancellable?
    
    func didStartHover() {
        if let token = self.hoverToken {
            token.cancel()
        }
        let endpoint = ToggleHighlightEndpoint(videoUID: self.videoItem.uid, highlight: true)
        self.hoverToken = self.dependencies.apiService.sendRequest(toEndpoint: endpoint, completion: { _ in })
    }
    
    func didFinishHover() {
        if let token = self.hoverToken {
            token.cancel()
        }
        let endpoint = ToggleHighlightEndpoint(videoUID: self.videoItem.uid, highlight: false)
        self.hoverToken = self.dependencies.apiService.sendRequest(toEndpoint: endpoint, completion: { _ in })
    }
    
    func didSelect() {
        let endpoint = EnablePiPEndpoint(videoUID: self.videoItem.uid)
        self.dependencies.apiService.sendRequest(toEndpoint: endpoint, completion: { _ in })
    }
}
