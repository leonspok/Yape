//
//  HighlightEndpoint.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

final class ToggleHighlightEndpoint: APIEndpointProtocol {
    typealias ResponseType = Never?
    let name: APIEndpointName = .toggleHighlight
    let params: [String: Any]?
    
    init(videoUID: VideoItem.Identifier, highlight: Bool) {
        self.params = [.uid: videoUID, .highlight: highlight]
    }
    
    func process(response: [String : Any]?) -> Result<Never?> {
        return .success(value: nil)
    }
}

fileprivate extension String {
    static let uid = "uid"
    static let highlight = "highlight"
}
