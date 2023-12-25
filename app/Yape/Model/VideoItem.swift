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
    let src: String?
    let title: String
    let isPlaying: Bool
    let duration: TimeInterval?
    
    var url: URL? {
        return self.src.flatMap(URL.init(string:))
    }
}

extension VideoItem: Equatable {
    static func ==(lhs: VideoItem, rhs: VideoItem) -> Bool {
        return lhs.uid == rhs.uid
    }
}

extension VideoItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uid.hashValue)
    }
}

extension VideoItem: DictionaryRepresentable {
    init?(dictionary: [String: Any]) {
        guard let uidString = dictionary[.uid] as? String,
            let title = dictionary[.title] as? String,
            let isPlaying = dictionary[.isPlaying] as? Bool else {
            return nil
        }
        self.uid = Identifier(rawValue: uidString)
        self.src = dictionary[.src] as? String
        self.title = title
        self.isPlaying = isPlaying
        self.duration = dictionary[.duration] as? TimeInterval
    }
    
    func asDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[.uid] = self.uid.rawValue
        dictionary[.title] = self.title
        dictionary[.isPlaying] = self.isPlaying
        if let duration = self.duration {
            dictionary[.duration] = duration
        }
        return dictionary
    }
}

// MARK: - Dictionary Keys

fileprivate extension String {
    static let uid = "uid"
    static let src = "src"
    static let title = "title"
    static let isPlaying = "is_playing"
    static let duration = "duration"
}
