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
    case toggleHighlight(videoId: VideoItem.Identifier, highlight: Bool)
    case enablePiP(videoId: VideoItem.Identifier)
}

extension ExtensionCommand {
    var name: String {
        switch self {
        case .exportVideos:
            return "export_videos"
        case .toggleHighlight:
            return "toggle_highlight"
        case .enablePiP:
            return "enable_pip"
        }
    }
    
    var userInfo: [String: Any]? {
        switch self {
        case .exportVideos:
            return nil
        case .toggleHighlight(let videoId, let highlight):
            return [.uid: videoId.rawValue,
                    .highlight: highlight]
        case .enablePiP(let videoId):
            return [.uid: videoId.rawValue]
        }
    }
}

fileprivate extension String {
    static let uid = "uid"
    static let highlight = "highlight"
}
