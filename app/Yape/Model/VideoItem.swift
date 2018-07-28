//
//  VideoItem.swift
//  Yape
//
//  Created by Igor Savelev on 21/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

struct VideoItem {
    typealias Identifier = GenericIdentifier<VideoItem>
    let uid: Identifier
    let title: String
    let isPlaying: Bool
}

extension VideoItem: Equatable {
    static func ==(lhs: VideoItem, rhs: VideoItem) -> Bool {
        return lhs.uid == rhs.uid
    }
}

extension VideoItem: Hashable {
    var hashValue: Int {
        return self.uid.hashValue
    }
}

extension VideoItem {
    init?(dictionary: [String: Any]) {
        guard let uidString = dictionary[.uid] as? String,
            let title = dictionary[.title] as? String,
            let isPlaying = dictionary[.isPlaying] as? Bool else {
            return nil
        }
        self.uid = Identifier(rawValue: uidString)
        self.title = title
        self.isPlaying = isPlaying
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [.uid: self.uid.rawValue,
                                         .title: self.title,
                                         .isPlaying: self.isPlaying]
        return dictionary
    }
}

// MARK: - Dictionary Keys

fileprivate extension String {
    static let uid = "uid"
    static let title = "title"
    static let isPlaying = "is_playing"
}
