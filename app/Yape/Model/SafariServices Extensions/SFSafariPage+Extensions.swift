//
//  SFSafariPage+Extensions.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import SafariServices

extension SFSafariPage {
    func send(message: ExtensionMessage) {
        let name = self.name(for: message)
        let params = self.params(for: message)
        self.dispatchMessageToScript(withName: name, userInfo: params)
    }
    
    private func name(for message: ExtensionMessage) -> String {
        switch message {
        case .getVideos:
            return "get_videos"
        case .enablePiP:
            return "enable_pip"
        case .toggleHighlight:
            return "toggle_highlight"
        }
    }
    
    private func params(for message: ExtensionMessage) -> [String: Any]? {
        switch message {
        case .enablePiP(let videoUID):
            return ["video_uid": videoUID]
        case .toggleHighlight(let videoUID, let highlight):
            return ["video_uid": videoUID,
                    "highlight": highlight]
        default:
            return nil
        }
    }
}
