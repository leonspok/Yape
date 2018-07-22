//
//  CommunicationService.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol CommunicationServiceProtocol {
    typealias Completion = (_ result: Result<[String: Any]?>) -> Void
    @discardableResult
    func send(request: CommunicationRequestProtocol, completion: @escaping Completion) -> Cancellable
}
