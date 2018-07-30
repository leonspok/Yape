//
//  VideoItemsCollection.swift
//  Yape
//
//  Created by Igor Savelev on 29/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

struct VideoItemsCollection {
    typealias Identifier = GenericIdentifier<VideoItemsCollection>
    let uid: Identifier
    let title: String
    let videos: [VideoItem]
    
    init(uid: Identifier,
         title: String,
         videos: [VideoItem]) {
        self.uid = uid
        self.title = title
        self.videos = videos
    }
}
