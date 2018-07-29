//
//  VideosListMessage.swift
//  Yape
//
//  Created by Igor Savelev on 29/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

struct VideosListMessage: ExtensionMessageProtocol {
    static let messageType: ExtensionMessageType = .concrete(name: .videosList)
    private let documentMessage: DocumentMessage<VideosListMessageInfo>
    var collection: VideoItemsCollection {
        return VideoItemsCollection(documentMessage: self.documentMessage)
    }
    
    init?(dictionary: [String : Any]) {
        guard let documentMessage = DocumentMessage<VideosListMessageInfo>(dictionary: dictionary) else {
            return nil
        }
        self.documentMessage = documentMessage
    }
    
    func asDictionary() -> [String : Any] {
        return self.documentMessage.asDictionary()
    }
}

fileprivate struct VideosListMessageInfo: ExtensionMessageInfoProtocol {
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

fileprivate extension VideoItemsCollection {
    init(documentMessage: DocumentMessage<VideosListMessageInfo>) {
        self.uid = Identifier(rawValue: documentMessage.documentInfo.uid.rawValue)
        self.title = {
            if let host = URL(string: documentMessage.documentInfo.location)?.host {
                if let title = documentMessage.documentInfo.title, title.count > 0 {
                    debugLog("[\(host)] " + title)
                    return "[\(host)] " + title
                }
                return "[\(host)]"
            } else {
                let location = documentMessage.documentInfo.location
                let truncated = location.prefix(min(location.count, 30))
                return "[\(truncated)]"
            }
        }()
        self.videos = documentMessage.messageInfo.items
    }
}
