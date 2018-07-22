//
//  GetVideosEndpoint.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

final class GetVideosEndpoint: APIEndpointProtocol {
    typealias ResponseType = [VideoItem]
    let name: APIEndpointName = .getVideos
    let params: [String : Any]? = nil
    
    func process(response: [String : Any]?) -> Result<[VideoItem]> {
        guard let response = response,
            let videosInfo = response[.videos] as? [[String: Any]] else {
            return .failure(error: APIEndpointError.responseProcessingFailed)
        }
        return .success(value: videosInfo.compactMap({ VideoItem(dictionary: $0) }))
    }
}

fileprivate extension String {
    static let videos = "videos"
}
