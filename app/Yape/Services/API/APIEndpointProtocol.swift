//
//  Endpoint.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

enum APIEndpointError: Error {
    case responseProcessingFailed
}

protocol APIEndpointProtocol {
    associatedtype ResponseType
    var name: APIEndpointName { get }
    var params: [String: Any]? { get }
    
    func process(response: [String: Any]?) -> Result<ResponseType>
}
