//
//  ExtensionMessage.swift
//  Yape
//
//  Created by Igor Savelev on 21/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

enum ExtensionMessage {
    case getVideos
    case toggleHighlight(videoUID: VideoItem.Identifier, highlight: Bool)
    case enablePiP(videoUID: VideoItem.Identifier)
}
