//
//  EnablePiPEndpoint.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

final class EnablePiPEndpoint: APIEndpointProtocol {
    typealias ResponseType = Never?
    let name: APIEndpointName = .enablePiP
    let params: [String: Any]?
    
    init(videoUID: VideoItem.Identifier) {
        self.params = [.uid: videoUID.rawValue]
    }
    
    func process(response: [String : Any]?) -> Result<Never?> {
        return .success(value: nil)
    }
}

fileprivate extension String {
    static let uid = "uid"
}
