//
//  VideosListMessage.swift
//  Yape
//
//  Created by Igor Savelev on 29/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

typealias VideosListMessage = DocumentMessage<VideosListMessageInfo>

struct VideosListMessageInfo: ExtensionMessageInfoProtocol {
    static let containingMessageType: ExtensionMessageType = .concrete(name: .videosList)
    let items: [VideoItem]
    
    init?(dictionary: [String : Any]) {
        guard let videosInfo = dictionary[.videos] as? [[String: Any]] else {
            return nil
        }
        self.items = videosInfo.compactMap({ VideoItem(dictionary: $0) })
    }
    
    func asDictionary() -> [String : Any] {
        return [.videos: self.items.map({ $0.asDictionary() })]
    }
}

fileprivate extension String {
    static let videos = "videos"
}
