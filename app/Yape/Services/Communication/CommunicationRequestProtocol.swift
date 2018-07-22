//
//  CommunicationRequestProtocol.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

enum CommunicationRequestError: Error {
    case requestTimeout
}

protocol CommunicationRequestProtocol {
    typealias Identifier = GenericIdentifier<CommunicationRequestProtocol>
    var uid: Identifier { get }
    var requestName: String { get }
    var params: [String: Any]? { get }
}
