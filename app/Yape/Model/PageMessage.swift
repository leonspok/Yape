//
//  PageMessage.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

enum PageMessage {
    case videosList(videos: [VideoItem])
}

extension PageMessage {
    init?(messageName: String, userInfo: [String: Any]?) {
        switch messageName {
        case "videos_list":
            guard let userInfo = userInfo,
                let videos = userInfo["videos"] as? [[String: Any]] else {
                return nil
            }
            self = .videosList(videos: videos.compactMap({ (videoInfo) -> VideoItem? in
                return VideoItem(dictionary: videoInfo)
            }))
        default:
            return nil
        }
    }
}
