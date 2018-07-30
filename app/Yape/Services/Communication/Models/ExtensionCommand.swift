//
//  ExtensionCommand.swift
//  Yape
//
//  Created by Igor Savelev on 28/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

enum ExtensionCommand {
    case exportVideos
    case highlightVideo(videoId: VideoItem.Identifier)
    case removeHighlight
    case scrollToVideo(videoId: VideoItem.Identifier)
    case enablePiP(videoId: VideoItem.Identifier)
}

extension ExtensionCommand {
    var name: String {
        switch self {
        case .exportVideos:
            return "export_videos"
        case .highlightVideo:
            return "highlight_video"
        case .scrollToVideo:
            return "scroll_to_video"
        case .removeHighlight:
            return "remove_highlight"
        case .enablePiP:
            return "enable_pip"
        }
    }
    
    var userInfo: [String: Any]? {
        switch self {
        case .exportVideos:
            return nil
        case .highlightVideo(let videoId):
            return [.uid: videoId.rawValue]
        case .removeHighlight:
            return nil
        case .scrollToVideo(let videoId):
            return [.uid: videoId.rawValue]
        case .enablePiP(let videoId):
            return [.uid: videoId.rawValue]
        }
    }
}

fileprivate extension String {
    static let uid = "uid"
}
